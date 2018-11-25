# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/github_setup'

RSpec.describe Github::UpdateOrCreate do
  setup_github_org_and_user

  let!(:issue) do
    VCR.use_cassette 'github/issues_created/success' do
      response = Github::Service.new(user, datetime).issues_created
      body     = JSON.parse response.body

      body['items'].last
    end
  end
  let(:issue_repo) { issue['repository_url'].split("#{org_name}/").last }
  let(:issue_user) { issue['user'] }
  let(:github_user) do
    GithubUser.find_by(github_login: user.github_username) || create_github_user
  end
  let(:org_id) { user.organization_id }

  describe '#repository!' do
    context 'when the repository already exists' do
      before { existing_repository }

      it 'returns the repository record with the response data', :aggregate_failures do
        repository = Github::UpdateOrCreate.new(issue, github_user, org_id).repository!

        expect(repository.name).to eq issue_repo
        expect(repository.url).to eq repository_url
        expect(repository.organization_id).to eq org.id
        expect(Repository.count).to eq 1
      end
    end

    context 'when the repository does not exist' do
      it 'creates and returns a repository record with the response data', :aggregate_failures do
        expect(Repository.count).to eq 0

        repository = Github::UpdateOrCreate.new(issue, github_user, org_id).repository!

        expect(repository.name).to eq issue_repo
        expect(repository.url).to eq repository_url
        expect(repository.organization_id).to eq org.id
        expect(Repository.count).to eq 1
      end
    end
  end

  describe '#statistic!' do
    context 'when the Statistic already exists' do
      before do
        create :repository, name: repository_name, organization_id: org.id, url: repository_url
      end
      let!(:stat) { existing_statistic }

      it 'updates and returns the Statistic record with the response data', :aggregate_failures do
        expect(Statistic.count).to eq 1
        expect(stat.state).to eq Statistic::CLOSED
        expect(stat.source_created_at).to eq initial_datetime
        expect(stat.source_updated_at).to eq initial_datetime

        statistic = Github::UpdateOrCreate.new(issue, github_user, org_id).statistic!

        expect(Statistic.count).to eq 1
        expect(stat.id).to eq statistic.id
        expect(statistic).to be_valid
        expect(statistic.source_id).to eq issue['id'].to_s
        expect(statistic.source_type).to eq issue_type_for(issue)
        expect(statistic.source).to eq Statistic::GITHUB
        expect(statistic.state).to eq issue['state']
        expect(statistic.repository_id).to eq repository_id
        expect(statistic.organization_id).to eq user.organization_id
        expect(statistic.url).to eq issue['html_url']
        expect(statistic.title).to eq issue['title']
        expect(statistic.source_created_at).to eq issue['created_at']
        expect(statistic.source_updated_at).to eq issue['updated_at']
        expect(statistic.source_created_by).to eq issue_user['id']
      end

      it "sets the #assignees array column to the current issue's assignee GitHub user ID's", :aggregate_failures do
        some_assignee_id = 9999
        stat.update! assignees: [some_assignee_id]
        expect(stat.assignees).to match_array [some_assignee_id]

        updated_statistic = Github::UpdateOrCreate.new(issue, user).statistic!

        expect(stat.id).to eq updated_statistic.id
        expect(updated_statistic.assignees).to match_array derive_assignees
      end

      context 'when the GithubUser is *not* already associated with the Statistic' do
        it 'creates an association between the GithubUser and the Statistic' do
          statistic = Statistic.first

          expect(statistic.github_users).to eq [github_user]
          statistic.github_users.delete github_user
          expect(statistic.github_users).to eq []

          updated_statistic = Github::UpdateOrCreate.new(issue, github_user, org_id).statistic!

          expect(updated_statistic).to eq statistic
          expect(updated_statistic.github_users).to eq [github_user]
        end
      end

      context 'when the GithubUser is already associated with the Statistic' do
        it 'does not duplicate the association' do
          statistic = Statistic.first

          expect(statistic.github_users).to eq [github_user]

          updated_statistic = Github::UpdateOrCreate.new(issue, github_user, org_id).statistic!

          expect(updated_statistic).to eq statistic
          expect(updated_statistic.github_users).to eq [github_user]
        end
      end
    end

    context 'when the Statistic does not exist' do
      it 'creates and returns the Statistic record with the response data', :aggregate_failures do
        expect(Statistic.count).to eq 0

        statistic = Github::UpdateOrCreate.new(issue, github_user, org_id).statistic!

        expect(Statistic.count).to eq 1
        expect(statistic).to be_valid
        expect(statistic.source_id).to eq issue['id'].to_s
        expect(statistic.source_type).to eq issue_type_for(issue)
        expect(statistic.source).to eq Statistic::GITHUB
        expect(statistic.state).to eq issue['state']
        expect(statistic.repository_id).to eq repository_id
        expect(statistic.organization_id).to eq user.organization_id
        expect(statistic.url).to eq issue['html_url']
        expect(statistic.title).to eq issue['title']
        expect(statistic.source_created_at).to eq issue['created_at']
        expect(statistic.source_updated_at).to eq issue['updated_at']
        expect(statistic.source_created_by).to eq issue_user['id']
      end

      it 'creates the associated Githubuser record, if one does not already exist', :aggregate_failures do
        expect(GithubUser.count).to eq 0

        statistic = Github::UpdateOrCreate.new(issue, github_user, org_id).statistic!

        expect(GithubUser.count).to eq 1
        expect(statistic.github_users.first).to eq GithubUser.first
      end

      it 'creates the associated Repository record, if one does not already exist', :aggregate_failures do
        expect(Repository.count).to eq 0

        statistic = Github::UpdateOrCreate.new(issue, github_user, org_id).statistic!

        expect(Repository.count).to eq 1
        expect(statistic.repository_id).to eq Repository.first.id
      end

      it 'associates the Statistic with its GithubUser', :aggregate_failures do
        expect(GithubUser.count).to eq 0

        statistic    = Github::UpdateOrCreate.new(issue, github_user, org_id).statistic!
        github_users = statistic.github_users

        expect(github_users).to be_present
        expect(github_users.first).to eq github_user
      end

      it "sets the #assignees array column to the current issue's assignee GitHub user ID's" do
        statistic = Github::UpdateOrCreate.new(issue, user).statistic!

        expect(statistic.assignees).to match_array derive_assignees
      end
    end
  end
end

def existing_repository
  create(
    :repository,
    name: issue_repo,
    url: "https://github.com/#{org_name}/#{issue_repo}",
    organization_id: org.id
  )
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

def issue_type_for(response)
  response['url'].include?('/issues/') ? Statistic::ISSUE : Statistic::PR
end

def repository_url
  issue['repository_url'].gsub('api.', '').gsub('repos/', '')
end

def repository_name
  repository_url.split('/').last
end

def repository_id
  Repository.find_by(name: repository_name).id
end

def existing_statistic
  statistic = Statistic.create(
    source_id: issue['id'].to_s,
    source_type: issue_type_for(issue),
    source: Statistic::GITHUB,
    state: Statistic::CLOSED,
    repository_id: repository_id,
    organization_id: user.organization_id,
    url: issue['html_url'],
    title: issue['title'],
    source_created_at: initial_datetime,
    source_updated_at: initial_datetime,
    source_created_by: issue_user['id']
  )

  github_user = create_github_user

  statistic.github_users << github_user
  statistic
end

def initial_datetime
  datetime = issue['created_at']
  datetime = Time.parse datetime
  datetime -= 1.day

  datetime.iso8601
end

def derive_assignees
  assignees = []
  assignees = assignees << issue.dig('assignee', 'id')
  assignees = assignees << issue.dig('assignees').map { |assignee| assignee['id'] }

  assignees.flatten.compact.uniq
end
