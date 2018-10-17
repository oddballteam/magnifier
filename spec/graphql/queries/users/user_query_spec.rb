# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Users::UserQuery do
  before { 3.times { create :user } }

  let(:user) { User.second }
  let(:fields) do
    %w[
      firstName
      lastName
      email
      githubUsername
      id
    ]
  end

  context 'with an argument of "github_username"' do
    let(:query) do
      <<-GRAPHQL
        query {
          user(githubUsername: "#{user.github_username}") {
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
    let(:results) { response.dig('data', 'user') }

    it 'returns the expected user', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq user.send(field.underscore)
      end
    end
  end

  context 'with an argument of "id"' do
    let(:query) do
      <<-GRAPHQL
        query {
          user(id: "#{user.id}") {
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
    let(:results) { response.dig('data', 'user') }

    it 'returns the expected user', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq user.send(field.underscore)
      end
    end
  end
end
