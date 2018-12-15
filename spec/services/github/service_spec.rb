# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/github_setup'

RSpec.describe Github::Service do
  setup_github_org_and_user

  context 'authorization criteria' do
    it 'will raise an error when user.github_username is not present' do
      invalid_user = build :user, github_username: nil

      expect do
        Github::Service.new(invalid_user, datetime)
      end.to raise_error Github::ServiceError
    end

    it 'will raise an error when user.personal_access_token is not present' do
      invalid_user = build :user, personal_access_token: nil

      expect do
        Github::Service.new(invalid_user, datetime)
      end.to raise_error Github::ServiceError
    end
  end

  describe '#issues_created' do
    it 'only returns issues', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        response = Github::Service.new(user, datetime).issues_created

        items_in(response).each do |item|
          html_url = item['html_url']

          expect(html_url.include?('/issues/')).to be true
        end
      end
    end

    it 'only returns issues for repositories within the passed organization', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        response = Github::Service.new(user, datetime).issues_created

        items_in(response).each do |item|
          repo_url = item['repository_url']

          expect(repo_url.include?(org_name)).to be true
        end
      end
    end

    it 'only returns issues where the passed user is the author', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        response = Github::Service.new(user, datetime).issues_created

        items_in(response).each do |item|
          expect(item.dig('user', 'login')).to eq github_username
        end
      end
    end

    it 'only returns issues where the created_at is >= the passed datetime', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        response = Github::Service.new(user, datetime).issues_created

        items_in(response).each do |item|
          expect(item['created_at']).to be >= datetime
        end
      end
    end

    it 'returns both open and closed issues' do
      VCR.use_cassette 'github/issues_created/success' do
        response = Github::Service.new(user, datetime).issues_created
        states   = items_in(response).map { |item| item['state'] }

        expect(states.uniq).to include('open', 'closed')
      end
    end

    context 'with missing search criteria' do
      it 'will raise an error when user.organization_id is not present' do
        user.update!(organization_id: nil)

        expect do
          Github::Service.new(user, datetime).issues_created
        end.to raise_error Github::ServiceError
      end

      it 'will raise an error when datetime is not present' do
        expect do
          Github::Service.new(user, nil).issues_created
        end.to raise_error Github::ServiceError
      end
    end

    context 'with a non 200 response' do
      it 'raises an error with details', :aggregate_failures do
        VCR.use_cassette 'github/issues_created/failure' do
          expect { Github::Service.new(user, datetime).issues_created }.to raise_error do |e|
            message = JSON.parse e.message

            expect(e).to be_a(Github::ServiceError)
            expect(message['status']).to eq(401)
            expect(message['body']).to be_present
            expect(message['user_id']).to be_present
            expect(message['source']).to be_present
          end
        end
      end
    end
  end

  describe '#issues_worked' do
    it 'only returns issues', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Service.new(user, datetime).issues_worked

        items_in(response).each do |item|
          html_url = item['html_url']

          expect(html_url.include?('/issues/')).to be true
        end
      end
    end

    it 'only returns issues for repositories within the passed organization', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Service.new(user, datetime).issues_worked

        items_in(response).each do |item|
          repo_url = item['repository_url']

          expect(repo_url.include?(org_name)).to be true
        end
      end
    end

    it 'only returns issues where the passed user is an assignee', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Service.new(user, datetime).issues_worked

        items_in(response).each do |item|
          assignee  = item.dig('assignee', 'login')
          assignees = item['assignees'].map { |user| user['login'] }

          if assignees
            expect(assignees.include?(github_username)).to be true
          else
            expect(assignee).to eq github_username
          end
        end
      end
    end

    it 'only returns issues where the updated_at is >= the passed datetime', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Service.new(user, datetime).issues_worked

        items_in(response).each do |item|
          expect(item['updated_at']).to be >= datetime
        end
      end
    end

    it 'returns both open and closed issues' do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Service.new(user, datetime).issues_worked
        states   = items_in(response).map { |item| item['state'] }

        expect(states.uniq).to include('open', 'closed')
      end
    end

    it 'for all closed issues, updated_at >= closed_at', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Service.new(user, datetime).issues_worked
        closed_issues = items_in(response).select { |item| item['state'] == 'closed' }

        closed_issues.each do |issue|
          expect(issue['updated_at']).to be >= issue['closed_at']
        end
      end
    end

    it 'for all open issues, closed_at is nil', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Service.new(user, datetime).issues_worked
        open_issues = items_in(response).select { |item| item['state'] == 'open' }

        open_issues.each do |issue|
          expect(issue['closed_at']).to be_nil
        end
      end
    end
  end

  describe '#pull_requests_worked' do
    it 'only returns pull requests', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        response = Github::Service.new(user, datetime).pull_requests_worked

        items_in(response).each do |item|
          html_url = item['html_url']

          expect(html_url.include?('/pull/')).to be true
        end
      end
    end

    it 'returns open and closed pull requests', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        response = Github::Service.new(user, datetime).pull_requests_worked
        states   = items_in(response).map { |item| item['state'] }

        expect(states.uniq).to match_array ['open', 'closed']
      end
    end

    it 'only returns pull requests where the passed user is the author', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        response = Github::Service.new(user, datetime).pull_requests_worked

        items_in(response).each do |item|
          expect(item.dig('user', 'login')).to eq github_username
        end
      end
    end

    it 'only returns pull requests for repositories within the passed organization', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        response = Github::Service.new(user, datetime).pull_requests_worked

        items_in(response).each do |item|
          repo_url = item['repository_url']

          expect(repo_url.include?(org_name)).to be true
        end
      end
    end

    it 'only returns pull requests where the updated_at is >= the passed datetime', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        response = Github::Service.new(user, datetime).pull_requests_worked

        items_in(response).each do |item|
          expect(item['updated_at']).to be >= datetime
        end
      end
    end
  end

  describe '#pull_requests_merged' do
    it 'only returns pull requests', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Service.new(user, datetime).pull_requests_merged

        items_in(response).each do |item|
          html_url = item['html_url']

          expect(html_url.include?('/pull/')).to be true
        end
      end
    end

    it 'only returns merged pull requests', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Service.new(user, datetime).pull_requests_merged
        states   = items_in(response).map { |item| item['state'] }

        expect(states.uniq).to eq ['closed']
      end
    end

    it 'only returns pull requests where the passed user is the author', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Service.new(user, datetime).pull_requests_merged

        items_in(response).each do |item|
          expect(item.dig('user', 'login')).to eq github_username
        end
      end
    end

    it 'only returns pull requests for repositories within the passed organization', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Service.new(user, datetime).pull_requests_merged

        items_in(response).each do |item|
          repo_url = item['repository_url']

          expect(repo_url.include?(org_name)).to be true
        end
      end
    end

    it 'only returns pull requests where the updated_at is >= the passed datetime', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Service.new(user, datetime).pull_requests_merged

        items_in(response).each do |item|
          expect(item['updated_at']).to be >= datetime
        end
      end
    end

    it 'all updated_at >= closed_at', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Service.new(user, datetime).pull_requests_merged
        closed_issues = items_in(response).select { |item| item['state'] == 'closed' }

        closed_issues.each do |issue|
          expect(issue['updated_at']).to be >= issue['closed_at']
        end
      end
    end

    it "returns pull requests from any of the organization's repositories", :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Service.new(user, datetime).pull_requests_merged
        prs      = items_in(response).map { |item| item['html_url'] }
        repos    = %w[
          /vets-website/pull/
          /vets-api/pull/
          /devops/pull/
          /vets.gov-team/pull/
        ]

        repos.each do |_repo|
          expect(prs.any? { |repo| repo.include? repo }).to be true
        end
      end
    end
  end

  describe '#github_user_account' do
    it 'fetchs the user#github_usernames GitHub user account details', :aggregate_failures do
      VCR.use_cassette 'github/github_user_account/success' do
        response = Github::Service.new(user, datetime).github_user_account
        user_response = response.parsed_response

        expect(user_response['login']).to eq user.github_username
        expect(user_response['avatar_url']).to be_present
        expect(user_response['url']).to be_present
        expect(user_response['html_url']).to be_present
        expect(user_response['id']).to be_present
      end
    end
  end
end

def items_in(response)
  body = JSON.parse response.body

  body['items']
end
