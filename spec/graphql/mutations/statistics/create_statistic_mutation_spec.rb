# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Statistics::CreateStatisticMutation do
  let(:sourceId) { '12345' }
  let(:sourceType) { 'pull_request' }
  let(:source) { 'github' }
  let(:state) { 'open' }
  let(:url) { 'https://api.github.com/repos/org/repo/issues/123' }
  let(:title) { 'Some title' }
  let(:sourceCreatedAt) { '2018-10-17T20:31:41Z' }
  let(:sourceUpdatedAt) { '2018-10-18T20:31:41Z' }
  let(:repository) { create :repository }
  let(:organization) { repository.organization }
  let(:mutation) do
    <<-GRAPHQL
      mutation {
        createStatistic(attributes: {
          sourceId: "#{sourceId}",
          sourceType: "#{sourceType}",
          source: "#{source}",
          state: "#{state}",
          repositoryId: #{repository.id},
          organizationId: #{organization.id},
          url: "#{url}",
          title: "#{title}",
          sourceCreatedAt: "#{sourceCreatedAt}",
          sourceUpdatedAt: "#{sourceUpdatedAt}"
        }) {
          statistic {
            source
            sourceId
            sourceType
            state
            repositoryId
            organizationId
            url
            title
            sourceCreatedAt
            sourceUpdatedAt
            id
          }
          errors
        }
      }
    GRAPHQL
  end

  it 'creates a Statistic record' do
    expect do
      MagnifierSchema.execute(mutation, context: {})
    end.to change { Statistic.count }.from(0).to(1)
  end

  it 'creates a Statistic record with the passed attributes', :aggregate_failures do
    MagnifierSchema.execute(mutation, context: {})

    statistic  = Statistic.first
    attributes = %w[
      sourceId
      sourceType
      source
      state
      url
      title
      sourceCreatedAt
      sourceUpdatedAt
    ]

    attributes.each do |attribute|
      expect(statistic.send(attribute.underscore)).to eq send(attribute)
    end
  end
end
