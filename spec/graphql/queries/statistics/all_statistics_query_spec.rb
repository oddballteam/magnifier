# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Statistics::AllStatisticsQuery do
  before { 6.times { create :statistic } }

  context 'with no arguments' do
    let(:query) do
      <<-GRAPHQL
        query {
          allStatistics {
            source
            sourceId
            sourceType
            state
            repositoryId
            organizationId
            url
            title
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'allStatistics') }

    it 'returns all Statistics in the db' do
      expect(results.size).to eq(6)
    end

    it 'returns the requested db attributes' do
      expect(results.first.keys).to match(
        %w[
          source
          sourceId
          sourceType
          state
          repositoryId
          organizationId
          url
          title
        ]
      )
    end
  end

  context 'with an argument of "limit"' do
    let(:limited_query) do
      <<-GRAPHQL
        query {
          allStatistics(limit: 3) {
            source
            sourceId
            sourceType
            state
            repositoryId
            organizationId
            url
            title
          }
        }
      GRAPHQL
    end

    it 'limits the response items to the requested limit' do
      response = MagnifierSchema.execute limited_query, context: {}
      results  = response.dig('data', 'allStatistics')

      expect(results.size).to eq(3)
    end
  end
end
