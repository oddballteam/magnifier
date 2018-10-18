# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::UsersQuery do
  before { 6.times { create :user } }

  context 'with no arguments' do
    let(:query) do
      <<-GRAPHQL
        query {
          users {
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
    let(:results) { response.dig('data', 'users') }

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
          users(limit: 3) {
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
      results  = response.dig('data', 'users')

      expect(results.size).to eq(3)
    end
  end
end
