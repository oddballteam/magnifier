# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/github_setup'

RSpec.describe Github::Persist do
  setup_github_org_and_user

  before { create_github_user }

  describe '#initialize' do
    it 'will raise an error when user.organization_id is not present' do
      invalid_user = build :user, organization_id: nil

      expect do
        Github::Persist.new(invalid_user, datetime)
      end.to raise_error Github::ServiceError
    end

    describe '#github_user' do
      context 'when the users GithubUser already exists' do
        it 'finds and returns the GithubUser', :aggregate_failures do
          expect(GithubUser.count).to eq 1
          expect(Github::Persist.new(user, datetime).github_user).to be_present
          expect(GithubUser.count).to eq 1
          expect(GithubUser.first.user_id).to eq user.id
        end
      end

      context 'when the users GithubUser does *not* already exist' do
        it 'creates and returns the GithubUser', :aggregate_failures do
          GithubUser.delete_all

          VCR.use_cassette 'github/github_user_account/success' do
            expect(Github::Persist.new(user, datetime).github_user).to be_present
            expect(GithubUser.count).to eq 1
            expect(GithubUser.first.user_id).to eq user.id
          end
        end
      end
    end
  end

  describe '#created_issues!' do
    it 'creates expected db records for all of the issues from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0

        Github::Persist.new(user, datetime).created_issues!

        expect(Statistic.count).to eq 9
        expect(Repository.count).to eq 1
      end
    end

    it 'returns Statistic records of type: issue', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        response = Github::Persist.new(user, datetime).created_issues!

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::ISSUE]
      end
    end
  end

  describe '#worked_issues!' do
    it 'creates expected db records for all of the issues from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0

        Github::Persist.new(user, datetime).worked_issues!

        expect(Statistic.count).to eq 62
        expect(Repository.count).to eq 1
      end
    end

    it 'returns Statistic records of type: issue', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        response = Github::Persist.new(user, datetime).worked_issues!

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::ISSUE]
      end
    end
  end

  describe '#worked_pull_requests!' do
    it 'creates expected db records for all of the PRs from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0

        Github::Persist.new(user, datetime).worked_pull_requests!

        expect(Statistic.count).to eq 2
        expect(Repository.count).to eq 2
      end
    end

    it 'returns open, pull request Statistic records', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        response = Github::Persist.new(user, datetime).worked_pull_requests!

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::PR]
        expect(response.map(&:state).uniq).to eq [Statistic::OPEN]
      end
    end
  end

  describe '#merged_pull_requests!' do
    it 'creates expected db records for all of the PRs from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0

        Github::Persist.new(user, datetime).merged_pull_requests!

        expect(Statistic.count).to eq 20
        expect(Repository.count).to eq 5
      end
    end

    it 'returns merged, pull request Statistic records', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        response = Github::Persist.new(user, datetime).merged_pull_requests!

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::PR]
        expect(response.map(&:state).uniq).to eq [Statistic::MERGED]
      end
    end
  end
end

def create_github_user
  VCR.use_cassette 'github/github_user_account/success' do
    response = Github::Service.new(user, datetime).github_user_account
    user_response = response.parsed_response

    create(
      :github_user,
      user_id: user.id,
      github_login: user.github_username,
      avatar_url: user_response['avatar_url'],
      api_url: user_response['url'],
      html_url:  user_response['html_url'],
      github_id: user_response['id'],
      oddball_employee: true
    )
  end
end
