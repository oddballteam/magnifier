# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Persist do
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

  describe '#created_issues!' do
    it 'creates statistics for all of the issues from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        response = Github::Persist.new(user, datetime).created_issues!

        expect(Statistic.count).to eq 9
        expect(Repository.count).to eq 1
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::ISSUE]
      end
    end
  end

  describe '#worked_issues!' do
    it 'creates statistics for all of the issues from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/issues_worked/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        response = Github::Persist.new(user, datetime).worked_issues!

        expect(Statistic.count).to eq 62
        expect(Repository.count).to eq 1
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::ISSUE]
      end
    end
  end

  describe '#worked_pull_requests!' do
    it 'creates statistics for all of the PRs from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_worked/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        response = Github::Persist.new(user, datetime).worked_pull_requests!

        expect(Statistic.count).to eq 2
        expect(Repository.count).to eq 2
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::PR]
        expect(response.map(&:state).uniq).to eq [Statistic::OPEN]
      end
    end
  end

  describe '#merged_pull_requests!' do
    it 'creates statistics for all of the PRs from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/pull_requests_merged/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        response = Github::Persist.new(user, datetime).merged_pull_requests!

        expect(Statistic.count).to eq 20
        expect(Repository.count).to eq 5
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1

        expect(response.map { |stat| stat.class.to_s }.uniq).to eq ['Statistic']
        expect(response.map(&:source_type).uniq).to eq [Statistic::PR]
        expect(response.map(&:state).uniq).to eq [Statistic::MERGED]
      end
    end
  end
end
