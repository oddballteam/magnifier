# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::UpdateOrCreate do
  let(:datetime) { '2018-09-01T20:43:46Z' }
  let(:personal_access_token) { SecureRandom.hex(16) }
  let(:org_name) { 'department-of-veterans-affairs' }
  let(:org) { create :organization, name: org_name }

  let(:github_username) { 'hpjaj' }
  let(:user) do
    create(
      :user,
      github_username: github_username,
      organization_id: org.id,
      personal_access_token: personal_access_token
    )
  end
  let!(:issue) do
    VCR.use_cassette 'github/issues_created/success' do
      response = Github::Service.new(user, datetime).issues_created
      body     = JSON.parse response.body

      body['items'].first
    end
  end
  let(:issue_repo) { issue['repository_url'].split("#{org_name}/").last }
  let(:issue_user) { issue['user'] }

  describe '#initialize' do
    it 'will raise an error when user.organization_id is not present' do
      invalid_user = build :user, organization_id: nil

      expect do
        Github::UpdateOrCreate.new(issue, invalid_user)
      end.to raise_error Github::ServiceError
    end
  end

  describe '#repository!' do
    context 'when the repository already exists' do
      before { existing_repository }

      it 'returns the repository record with the response data', :aggregate_failures do
        repository = Github::UpdateOrCreate.new(issue, user).repository!

        expect(repository.name).to eq issue_repo
        expect(repository.url).to eq repository_url
        expect(repository.organization_id).to eq org.id
        expect(Repository.count).to eq 1
      end
    end

    context 'when the repository does not exist' do
      it 'creates and returns a repository record with the response data', :aggregate_failures do
        expect(Repository.count).to eq 0

        repository = Github::UpdateOrCreate.new(issue, user).repository!

        expect(repository.name).to eq issue_repo
        expect(repository.url).to eq repository_url
        expect(repository.organization_id).to eq org.id
        expect(Repository.count).to eq 1
      end
    end
  end

  describe '#github_user!' do
    context 'when the GithubUser already exists' do
      before { existing_github_user }

      it 'returns the GithubUser record with the response data', :aggregate_failures do
        expect(GithubUser.count).to eq 1

        github_user = Github::UpdateOrCreate.new(issue, user).github_user!

        expect(GithubUser.count).to eq 1
        expect(github_user.github_login). to eq user.github_username
      end
    end

    context 'when the GithubUser does not exist' do
      it 'creates and returns the GithubUser record with the response data', :aggregate_failures do
        expect(GithubUser.count).to eq 0

        github_user = Github::UpdateOrCreate.new(issue, user).github_user!

        expect(GithubUser.count).to eq 1
        expect(github_user).to be_valid
        expect(github_user.github_login). to eq user.github_username
        expect(github_user.user_id). to eq user.id
        expect(github_user.avatar_url). to eq issue_user['avatar_url']
        expect(github_user.api_url). to eq issue_user['url']
        expect(github_user.html_url). to eq issue_user['html_url']
        expect(github_user.github_id). to eq issue_user['id']
        expect(github_user.oddball_employee). to eq true
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

        statistic = Github::UpdateOrCreate.new(issue, user).statistic!

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
      end
    end

    context 'when the Statistic does not exist' do
      it 'creates and returns the Statistic record with the response data', :aggregate_failures do
        expect(Statistic.count).to eq 0

        statistic = Github::UpdateOrCreate.new(issue, user).statistic!

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
      end

      it 'creates the associated Githubuser record, if one does not already exist', :aggregate_failures do
        expect(GithubUser.count).to eq 0

        statistic = Github::UpdateOrCreate.new(issue, user).statistic!

        expect(GithubUser.count).to eq 1
        expect(statistic.github_users.first).to eq GithubUser.first
      end

      it 'creates the associated Repository record, if one does not already exist', :aggregate_failures do
        expect(Repository.count).to eq 0

        statistic = Github::UpdateOrCreate.new(issue, user).statistic!

        expect(Repository.count).to eq 1
        expect(statistic.repository_id).to eq Repository.first.id
      end

      it 'associates the Statistic with its GithubUser', :aggregate_failures do
        expect(GithubUser.count).to eq 0

        statistic    = Github::UpdateOrCreate.new(issue, user).statistic!
        github_users = statistic.github_users
        github_user  = GithubUser.first

        expect(github_users).to be_present
        expect(github_users.first).to eq github_user
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

def existing_github_user
  create(
    :github_user,
    user_id: user.id,
    github_login: user.github_username,
    avatar_url: issue_user['avatar_url'],
    api_url: issue_user['url'],
    html_url:  issue_user['html_url'],
    github_id: issue_user['id'],
    oddball_employee: true
  )
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
    source_updated_at: initial_datetime
  )

  github_user = create(
    :github_user,
    github_login: github_username,
    github_id: issue_user['id'],
    user_id: user.id
  )
  statistic.github_users << github_user
  statistic
end

def initial_datetime
  datetime = issue['created_at']
  datetime = Time.parse datetime
  datetime = datetime - 1.day

  datetime.iso8601
end
