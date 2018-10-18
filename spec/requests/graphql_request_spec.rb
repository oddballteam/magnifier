# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GraphQL requests', type: :request do
  describe '/graphql' do
    before { 3.times { create :organization } }

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

    it 'queries our GraphQL schema and returns the expected response', :aggregated_failures do
      post '/graphql', params: { query: query }

      body = JSON.parse(response.body)
      results = body.dig('data', 'allOrganizations')

      expect(results.length).to eq 3
      expect(results.first.keys).to match(
        %w[
          url
          name
          createdAt
          updatedAt
        ]
      )
    end

    context 'with a malformed query' do
      let(:bad_query) do
        <<-GRAPHQL
          query {
            allOrganizations {
            }
          }
        GRAPHQL
      end

      it 'surfaces the relevant error', :aggregated_failures do
        post '/graphql', params: { query: bad_query }

        body = JSON.parse(response.body)
        errors = body.dig('errors')
        message = errors.first['message']

        expect(errors).to be_present
        expect(message).to be_present
      end
    end
  end
end
