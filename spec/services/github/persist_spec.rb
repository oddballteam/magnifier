# frozen_string_literal: true

require 'rails_helper'
require_relative '../../support/github_setup'

RSpec.describe Github::Persist do
  setup_github_org_and_user

  describe '#created_issues!' do
    it 'creates expected db records for all of the issues from the GitHub API response', :aggregate_failures do
      VCR.use_cassette 'github/issues_created/success' do
        expect(Statistic.count).to eq 0
        expect(Repository.count).to eq 0
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        Github::Persist.new(user, datetime).created_issues!

        expect(Statistic.count).to eq 9
        expect(Repository.count).to eq 1
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1
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
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        Github::Persist.new(user, datetime).worked_issues!

        expect(Statistic.count).to eq 62
        expect(Repository.count).to eq 1
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1
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
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        Github::Persist.new(user, datetime).worked_pull_requests!

        expect(Statistic.count).to eq 2
        expect(Repository.count).to eq 2
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1
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
        expect(Organization.count).to eq 0
        expect(GithubUser.count).to eq 0

        Github::Persist.new(user, datetime).merged_pull_requests!

        expect(Statistic.count).to eq 20
        expect(Repository.count).to eq 5
        expect(Organization.count).to eq 1
        expect(GithubUser.count).to eq 1
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
