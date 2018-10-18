# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Repositories::RepositoryQuery do
  before { 3.times { create :repository } }

  let(:repository) { Repository.second }
  let(:fields) do
    %w[
      name
      url
    ]
  end

  context 'with an argument of "name"' do
    let(:query) do
      <<-GRAPHQL
        query {
          repository(name: "#{repository.name}") {
            name
            url
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'repository') }

    it 'returns the expected repository', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq repository.send(field.underscore)
      end
    end
  end

  context 'with an argument of "id"' do
    let(:query) do
      <<-GRAPHQL
        query {
          repository(id: "#{repository.id}") {
            name
            url
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'repository') }

    it 'returns the expected repository', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq repository.send(field.underscore)
      end
    end
  end
end
