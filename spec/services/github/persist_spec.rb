# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/github_setup'

RSpec.describe Github::Persist do
  setup_github_org_and_user
  let(:github_user) { GithubUser.find_by(github_login: user.github_username) }

  before { create_github_user }

  describe '#initialize' do
    context 'when #github_url is nil' do
      it 'will raise an error when user.organization_id is not present' do
        invalid_user = build :user, organization_id: nil

        expect do
          Github::Persist.new(invalid_user, datetime)
        end.to raise_error Github::ServiceError
      end
    end

    context 'when #github_url is present' do
      let(:owner) { 'oddballio' }
      let(:github_url) { "https://github.com/#{owner}/magnifier/pull/93" }

      it 'sets #org_id to the ID of the github_urls found or created organization#id' do
        persist = Github::Persist.new(user, github_url: github_url)
        oddball = Organization.find_by(name: owner)

        expect(persist.org_id).to eq oddball.id
      end

      context 'and the associated Organization does not exist in the db' do
        it 'creates the associated Organization' do
          expect(Organization.find_by(name: owner)).to be_nil

          Github::Persist.new(user, github_url: github_url)

          expect(Organization.find_by(name: owner)).to be_present
        end
      end

      context 'and the associated Organization already exists in the db' do
        let!(:organization) { create :organization, name: owner }

        it 'finds the associated Organization' do
          Github::Persist.new(user, github_url: github_url)

          expect(Organization.find_by(name: owner)).to eq organization
        end
      end
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

        expect(Statistic.count).to eq 23
        expect(Repository.count).to eq 5
      end
    end

    it 'returns open or closed pull request Statistic records', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        response = Github::Persist.new(user, datetime).worked_pull_requests!

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::PR]
        expect(response.map(&:state).uniq).to match_array [Statistic::OPEN, Statistic::CLOSED]
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

  describe '#issue!' do
    let(:owner) { 'oddballio' }
    let(:github_url) { "https://github.com/#{owner}/magnifier/issues/92" }

    it 'creates an issue Statistic record for the passed github_url', :aggregate_failures do
      VCR.use_cassette 'github/issue/new_org' do
        expect(Statistic.count).to eq 0

        statistic = Github::Persist.new(user, github_url: github_url).issue!

        expect(Statistic.count).to eq 1
        expect(statistic.source_type).to eq Statistic::ISSUE
      end
    end

    it 'sets the Statistics url to the passed github_url' do
      VCR.use_cassette 'github/issue/new_org' do
        statistic = Github::Persist.new(user, github_url: github_url).issue!

        expect(statistic.url).to eq github_url
      end
    end

    it 'sets the Statistics organization_id to the passed github_urls org id' do
      VCR.use_cassette 'github/issue/new_org' do
        statistic = Github::Persist.new(user, github_url: github_url).issue!
        organization = Organization.find_by(name: owner)

        expect(statistic.organization_id).to eq organization.id
      end
    end

    it 'associates the Statistic with the users GithubUser' do
      VCR.use_cassette 'github/issue/new_org' do
        statistic = Github::Persist.new(user, github_url: github_url).issue!

        expect(github_user.statistics).to include statistic
      end
    end
  end

  describe '#pull_request!' do
    context 'when the pull request is merged' do
      let(:owner) { 'oddballio' }
      let(:github_url) { "https://github.com/#{owner}/magnifier/pull/91" }

      it 'creates a merged pull request Statistic record for the passed github_url', :aggregate_failures do
        VCR.use_cassette 'github/pull_request/merged' do
          expect(Statistic.count).to eq 0

          statistic = Github::Persist.new(user, github_url: github_url).pull_request!

          expect(Statistic.count).to eq 1
          expect(statistic.source_type).to eq Statistic::PR
          expect(statistic.state).to eq Statistic::MERGED
          expect(statistic.source_closed_at).to be_present
        end
      end

      it 'sets the Statistics url to the passed github_url' do
        VCR.use_cassette 'github/pull_request/merged' do
          statistic = Github::Persist.new(user, github_url: github_url).pull_request!

          expect(statistic.url).to eq github_url
        end
      end

      it 'sets the Statistics organization_id to the passed github_urls org id' do
        VCR.use_cassette 'github/pull_request/merged' do
          statistic    = Github::Persist.new(user, github_url: github_url).pull_request!
          organization = Organization.find_by(name: owner)

          expect(statistic.organization_id).to eq organization.id
        end
      end

      it 'associates the Statistic with the users GithubUser' do
        VCR.use_cassette 'github/pull_request/merged' do
          statistic = Github::Persist.new(user, github_url: github_url).pull_request!

          expect(github_user.statistics).to include statistic
        end
      end
    end

    context 'when the pull request is open' do
      let(:owner) { 'oddballio' }
      let(:github_url) { "https://github.com/#{owner}/magnifier/pull/93" }

      it 'creates an open pull request Statistic record for the passed github_url', :aggregate_failures do
        VCR.use_cassette 'github/pull_request/open' do
          expect(Statistic.count).to eq 0

          statistic    = Github::Persist.new(user, github_url: github_url).pull_request!
          organization = Organization.find_by(name: owner)

          expect(Statistic.count).to eq 1
          expect(statistic.source_type).to eq Statistic::PR
          expect(statistic.state).to eq Statistic::OPEN
          expect(statistic.source_closed_at).to be_nil
          expect(statistic.organization_id).to eq organization.id
          expect(statistic.url).to eq github_url
          expect(github_user.statistics).to include statistic
        end
      end
    end

    context 'when the pull request is closed' do
      let(:owner) { 'department-of-veterans-affairs' }
      let(:github_url) { "https://github.com/#{owner}/vets-api/pull/2664" }

      it 'creates a closed pull request Statistic record for the passed github_url', :aggregate_failures do
        VCR.use_cassette 'github/pull_request/closed' do
          expect(Statistic.count).to eq 0

          statistic    = Github::Persist.new(user, github_url: github_url).pull_request!
          organization = Organization.find_by(name: owner)

          expect(Statistic.count).to eq 1
          expect(statistic.source_type).to eq Statistic::PR
          expect(statistic.state).to eq Statistic::CLOSED
          expect(statistic.source_closed_at).to be_present
          expect(statistic.organization_id).to eq organization.id
          expect(statistic.url).to eq github_url
          expect(github_user.statistics).to include statistic
        end
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
