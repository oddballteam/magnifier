# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::GithubUsers::GithubUserQuery do
  before { 3.times { create :github_user } }

  let(:github_user) { GithubUser.second }
  let(:fields) do
    %w[
      githubLogin
      id
      userId
      githubId
    ]
  end

  context 'with an argument of "github_login"' do
    let(:query) do
      <<-GRAPHQL
        query {
          githubUser(githubLogin: "#{github_user.github_login}") {
            githubLogin
            id
            userId
            githubId
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'githubUser') }

    it 'returns the expected GithubUser', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq github_user.send(field.underscore)
      end
    end
  end

  context 'with an argument of "id"' do
    let(:query) do
      <<-GRAPHQL
        query {
          githubUser(id: "#{github_user.id}") {
            githubLogin
            id
            userId
            githubId
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'githubUser') }

    it 'returns the expected GithubUser', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq github_user.send(field.underscore)
      end
    end
  end
end
