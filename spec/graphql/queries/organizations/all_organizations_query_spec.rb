# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Organizations::AllOrganizationsQuery do
  before { 6.times { create :organization } }

  context 'with no arguments' do
    let(:query) do
      <<-GRAPHQL
        query {
          allOrganizations {
            url
            name
            createdAt
            updatedAt
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'allOrganizations') }

    it 'returns all organizations in the db' do
      expect(results.size).to eq(6)
    end

    it 'returns the requested db attributes' do
      expect(results.first.keys).to match(
        %w[
          url
          name
          createdAt
          updatedAt
        ]
      )
    end
  end

  context 'with an argument of "limit"' do
    let(:limited_query) do
      <<-GRAPHQL
        query {
          allOrganizations(limit: 3) {
            url
            name
          }
        }
      GRAPHQL
    end

    it 'limits the response items to the requested limit' do
      response = MagnifierSchema.execute limited_query, context: {}
      results  = response.dig('data', 'allOrganizations')

      expect(results.size).to eq(3)
    end
  end
end
