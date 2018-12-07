# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::GithubUsers::GithubUsersQuery do
  before do
    user = create :user
    6.times { create :github_user, user_id: user.id }
  end

  context 'with no arguments' do
    let(:query) do
      <<-GRAPHQL
        query {
          githubUsers {
            githubLogin
            id
            userId
            githubId
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'githubUsers') }

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
          githubUsers(limit: 3) {
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
      results  = response.dig('data', 'githubUsers')

      expect(results.size).to eq(3)
    end
  end

  context 'with an argument of "has_user"' do
    let(:has_user_query) do
      <<-GRAPHQL
        query {
          githubUsers(has_user: false) {
            githubLogin
            id
            userId
            githubId
          }
        }
      GRAPHQL
    end

    it 'limits the response items where user_id is populated' do
      response = MagnifierSchema.execute has_user_query, context: {}
      results  = response.dig('data', 'githubUsers')

      expect(results).to be_nil
    end
  end
end
