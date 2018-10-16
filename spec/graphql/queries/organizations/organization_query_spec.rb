# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Organizations::OrganizationQuery do
  before { 3.times { create :organization } }

  let(:org) { Organization.second }
  let(:fields) { %w[id url name] }

  context 'with an argument of "name"' do
    let(:query) do
      <<-GRAPHQL
        query {
          organization(name: "#{org.name}") {
            id
            url
            name
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'organization') }

    it 'returns the expected organization', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq org.send(field)
      end
    end
  end

  context 'with an argument of "id"' do
    let(:query) do
      <<-GRAPHQL
        query {
          organization(id: "#{org.id}") {
            id
            url
            name
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'organization') }

    it 'returns the expected organization', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq org.send(field)
      end
    end
  end
end
