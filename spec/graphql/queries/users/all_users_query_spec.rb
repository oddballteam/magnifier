# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::AllUsersQuery do
  before { 6.times { create :user } }

  context 'with no arguments' do
    let(:query) do
      <<-GRAPHQL
        query {
          allUsers {
            firstName
            lastName
            email
            githubUsername
            id
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'allUsers') }

    it 'returns all Users in the db' do
      expect(results.size).to eq(6)
    end

    it 'returns the requested db attributes' do
      expect(results.first.keys).to match(
        %w[
          firstName
          lastName
          email
          githubUsername
          id
        ]
      )
    end
  end

  context 'with an argument of "limit"' do
    let(:limited_query) do
      <<-GRAPHQL
        query {
          allUsers(limit: 3) {
            firstName
            lastName
            email
            githubUsername
            id
          }
        }
      GRAPHQL
    end

    it 'limits the response items to the requested limit' do
      response = MagnifierSchema.execute limited_query, context: {}
      results  = response.dig('data', 'allUsers')

      expect(results.size).to eq(3)
    end
  end
end
