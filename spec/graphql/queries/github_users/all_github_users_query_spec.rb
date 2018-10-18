# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::GithubUsers::AllGithubUsersQuery do
  before { 6.times { create :github_user } }

  context 'with no arguments' do
    let(:query) do
      <<-GRAPHQL
        query {
          allGithubUsers {
            githubLogin
            id
            userId
            githubId
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'allGithubUsers') }

    it 'returns all Github Users in the db' do
      expect(results.size).to eq(6)
    end

    it 'returns the requested db attributes' do
      expect(results.first.keys).to match(
        %w[
          githubLogin
          id
          userId
          githubId
        ]
      )
    end
  end

  context 'with an argument of "limit"' do
    let(:limited_query) do
      <<-GRAPHQL
        query {
          allGithubUsers(limit: 3) {
            githubLogin
            id
            userId
            githubId
          }
        }
      GRAPHQL
    end

    it 'limits the response items to the requested limit' do
      response = MagnifierSchema.execute limited_query, context: {}
      results  = response.dig('data', 'allGithubUsers')

      expect(results.size).to eq(3)
    end
  end
end
