# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::Statistics::StatisticQuery do
  before { 3.times { create :statistic } }

  let(:statistic) { Statistic.second }
  let(:fields) do
    %w[
      source
      sourceId
      sourceType
      state
      repositoryId
      organizationId
      url
      title
    ]
  end

  context 'with an argument of "source_id"' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistic(sourceId: "#{statistic.source_id}") {
            source
            sourceId
            sourceType
            state
            repositoryId
            organizationId
            url
            title
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistic') }

    it 'returns the expected statistic', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq statistic.send(field.underscore)
      end
    end
  end

  context 'with an argument of "id"' do
    let(:query) do
      <<-GRAPHQL
        query {
          statistic(id: "#{statistic.id}") {
            source
            sourceId
            sourceType
            state
            repositoryId
            organizationId
            url
            title
          }
        }
      GRAPHQL
    end
    let(:response) { MagnifierSchema.execute(query, context: {}) }
    let(:results) { response.dig('data', 'statistic') }

    it 'returns the expected statistic', :aggregate_failures do
      fields.each do |field|
        expect(results[field]).to eq statistic.send(field.underscore)
      end
    end
  end
end
