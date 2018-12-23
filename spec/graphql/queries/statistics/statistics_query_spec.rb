# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Statistics::StatisticsQuery do
  let(:github_user) { create :github_user }
  let(:january_1_2018) { '2018-01-01T01:31:41Z' }

  before do
    create :statistic, :open_pr, source_created_by: github_user.github_id
    create :statistic, :closed_pr, source_created_by: github_user.github_id
    create :statistic, :merged_pr, source_created_by: github_user.github_id
    create :statistic, :open_issue, source_created_by: github_user.github_id
    create :statistic, :closed_issue, source_created_by: github_user.github_id
    create :statistic, :open_issue, assignees: [github_user.github_id]
    create :statistic, :closed_issue, assignees: [github_user.github_id]
  end

  context 'when requesting fields' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistics(
            ownershipType: CREATED,
            githubUserId: #{github_user.github_id},
            type: [ISSUE],
            state: [OPEN],
            datetimeType: CREATED,
            datetime: "#{january_1_2018}"
          ) {
            source
            sourceId
            repositoryId
            organizationId
            url
            title
            sourceType
            state
            sourceCreatedAt
            sourceCreatedBy
          }
        }
      GRAPHQL
    end

    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistics') }

    it 'returns the requested fields' do
      expect(results.first.keys).to match(
        %w[
          source
          sourceId
          repositoryId
          organizationId
          url
          title
          sourceType
          state
          sourceCreatedAt
          sourceCreatedBy
        ]
      )
    end
  end

  context 'for issues the user created' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistics(
            ownershipType: CREATED,
            githubUserId: #{github_user.github_id},
            type: [ISSUE],
            state: [OPEN, CLOSED],
            datetimeType: CREATED,
            datetime: "#{january_1_2018}"
          ) {
            sourceType
            state
            sourceCreatedAt
            sourceCreatedBy
          }
        }
      GRAPHQL
    end

    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistics') }

    it 'returns open and closed issues', :aggregated_failures do
      source_types = isolated_values_for(results, 'sourceType')
      states       = isolated_values_for(results, 'state')

      expect(source_types).to eq [Statistic::ISSUE]
      expect(states).to match_array [Statistic::OPEN, Statistic::CLOSED]
    end

    it 'only returns issues created by the passed GithubUser#github_id' do
      creator_ids = isolated_values_for(results, 'sourceCreatedBy')

      expect(creator_ids).to eq [github_user.github_id]
    end

    it 'only returns issues that were created after the passed datetime' do
      stats_created_after_datetime = stats_after_passed_datetime(results, 'sourceCreatedAt')

      expect(stats_created_after_datetime).to eq(2)
    end
  end

  context 'for issues the user worked' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistics(
            ownershipType: ASSIGNED,
            githubUserId: #{github_user.github_id},
            type: [ISSUE],
            state: [OPEN, CLOSED],
            datetimeType: UPDATED,
            datetime: "#{january_1_2018}"
          ) {
            sourceType
            state
            sourceUpdatedAt
            assignees
          }
        }
      GRAPHQL
    end

    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistics') }

    it 'returns open and closed issues', :aggregated_failures do
      source_types = isolated_values_for(results, 'sourceType')
      states       = isolated_values_for(results, 'state')

      expect(source_types).to eq [Statistic::ISSUE]
      expect(states).to match_array [Statistic::OPEN, Statistic::CLOSED]
    end

    it 'only returns issues assigned to the passed GithubUser#github_id' do
      assignee_ids = isolated_values_for(results, 'assignees').flatten

      expect(assignee_ids).to eq [github_user.github_id]
    end

    it 'only returns issues that were updated after the passed datetime' do
      stats_updated_after_datetime = stats_after_passed_datetime(results, 'sourceUpdatedAt')

      expect(stats_updated_after_datetime).to eq(2)
    end
  end

  context 'for issues the user closed' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistics(
            ownershipType: ASSIGNED,
            githubUserId: #{github_user.github_id},
            type: [ISSUE],
            state: [CLOSED],
            datetimeType: CLOSED,
            datetime: "#{january_1_2018}"
          ) {
            sourceType
            state
            sourceClosedAt
            assignees
          }
        }
      GRAPHQL
    end

    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistics') }

    it 'only returns closed issues', :aggregated_failures do
      source_types = isolated_values_for(results, 'sourceType')
      states       = isolated_values_for(results, 'state')

      expect(source_types).to eq [Statistic::ISSUE]
      expect(states).to match_array [Statistic::CLOSED]
    end

    it 'only returns issues assigned to the passed GithubUser#github_id' do
      assignee_ids = isolated_values_for(results, 'assignees').flatten

      expect(assignee_ids).to eq [github_user.github_id]
    end

    it 'only returns issues that were closed after the passed datetime' do
      stats_closed_after_datetime = stats_after_passed_datetime(results, 'sourceClosedAt')

      expect(stats_closed_after_datetime).to eq(1)
    end
  end

  context 'for pull requests the user created' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistics(
            ownershipType: CREATED,
            githubUserId: #{github_user.github_id},
            type: [PR],
            state: [OPEN, CLOSED, MERGED],
            datetimeType: CREATED,
            datetime: "#{january_1_2018}"
          ) {
            sourceType
            state
            sourceCreatedAt
            sourceCreatedBy
          }
        }
      GRAPHQL
    end

    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistics') }

    it 'returns open, closed and merged pull requests', :aggregated_failures do
      source_types = isolated_values_for(results, 'sourceType')
      states       = isolated_values_for(results, 'state')

      expect(source_types).to eq [Statistic::PR]
      expect(states).to match_array [Statistic::OPEN, Statistic::CLOSED, Statistic::MERGED]
    end

    it 'only returns pull requests created by the passed GithubUser#github_id' do
      creator_ids = isolated_values_for(results, 'sourceCreatedBy')

      expect(creator_ids).to eq [github_user.github_id]
    end

    it 'only returns pull requests that were created after the passed datetime' do
      stats_created_after_datetime = stats_after_passed_datetime(results, 'sourceCreatedAt')

      expect(stats_created_after_datetime).to eq(3)
    end
  end

  context 'for pull requests the user worked' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistics(
            ownershipType: CREATED,
            githubUserId: #{github_user.github_id},
            type: [PR],
            state: [OPEN, CLOSED, MERGED],
            datetimeType: UPDATED,
            datetime: "#{january_1_2018}"
          ) {
            sourceType
            state
            sourceUpdatedAt
            sourceCreatedBy
          }
        }
      GRAPHQL
    end

    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistics') }

    it 'returns open, closed and merged pull requests', :aggregated_failures do
      source_types = isolated_values_for(results, 'sourceType')
      states       = isolated_values_for(results, 'state')

      expect(source_types).to eq [Statistic::PR]
      expect(states).to match_array [Statistic::OPEN, Statistic::CLOSED, Statistic::MERGED]
    end

    it 'only returns pull requests created by the passed GithubUser#github_id' do
      creator_ids = isolated_values_for(results, 'sourceCreatedBy')

      expect(creator_ids).to eq [github_user.github_id]
    end

    it 'only returns pull requests that were updated after the passed datetime' do
      stats_updated_after_datetime = stats_after_passed_datetime(results, 'sourceUpdatedAt')

      expect(stats_updated_after_datetime).to eq(3)
    end
  end

  context 'for pull requests the user merged' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistics(
            ownershipType: CREATED,
            githubUserId: #{github_user.github_id},
            type: [PR],
            state: [MERGED],
            datetimeType: CLOSED,
            datetime: "#{january_1_2018}"
          ) {
            sourceType
            state
            sourceClosedAt
            sourceCreatedBy
          }
        }
      GRAPHQL
    end

    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistics') }

    it 'only returns merged pull requests', :aggregated_failures do
      source_types = isolated_values_for(results, 'sourceType')
      states       = isolated_values_for(results, 'state')

      expect(source_types).to eq [Statistic::PR]
      expect(states).to match_array [Statistic::MERGED]
    end

    it 'only returns pull requests created by the passed GithubUser#github_id' do
      creator_ids = isolated_values_for(results, 'sourceCreatedBy')

      expect(creator_ids).to eq [github_user.github_id]
    end

    it 'only returns pull requests that were merged after the passed datetime' do
      stats_merged_after_datetime = stats_after_passed_datetime(results, 'sourceClosedAt')

      expect(stats_merged_after_datetime).to eq(1)
    end
  end
end

def isolated_values_for(results, field)
  results.map { |statistic| statistic[field] }.uniq
end

def stats_after_passed_datetime(results, field)
  results.select { |stat| stat[field] > january_1_2018 }.count
end
