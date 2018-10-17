# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Repositories::AllRepositoriesQuery do
  before { 6.times { create :repository } }

  context 'with no arguments' do
    let(:query) do
      <<-GRAPHQL
        query {
          allRepositories {
            name
            url
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'allRepositories') }

    it 'returns all Repositories in the db' do
      expect(results.size).to eq(6)
    end

    it 'returns the requested db attributes' do
      expect(results.first.keys).to match(
        %w[
          name
          url
        ]
      )
    end
  end

  context 'with an argument of "limit"' do
    let(:limited_query) do
      <<-GRAPHQL
        query {
          allRepositories(limit: 3) {
            name
            url
          }
        }
      GRAPHQL
    end

    it 'limits the response items to the requested limit' do
      response = MagnifierSchema.execute limited_query, context: {}
      results  = response.dig('data', 'allRepositories')

      expect(results.size).to eq(3)
    end
  end
end
