# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Statistics::UpdateStatisticMutation do
  let!(:statistic) { create :statistic }
  let(:original_title) { statistic.title }
  let(:new_title) { 'Some new title' }
  let(:mutation) do
    <<-GRAPHQL
      mutation {
        updateStatistic(
          id: #{statistic.id},
          attributes: {
            sourceId: "#{statistic.source_id}",
            sourceType: "#{statistic.source_type}",
            source: "#{statistic.source}",
            state: "#{statistic.state}",
            organizationId: #{statistic.organization.id},
            url: "#{statistic.url}",
            title: "#{new_title}",
            sourceCreatedAt: "#{statistic.source_created_at}",
            sourceUpdatedAt: "#{statistic.source_updated_at}"
          }
        ) {
          statistic {
            source
            sourceId
            sourceType
            state
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

  it 'does not create a new Statistic record' do
    expect do
      MagnifierSchema.execute(mutation, context: {})
    end.to change { Statistic.count }.by(0)
  end

  it 'updates a Statistic record with the passed attributes', :aggregate_failures do
    expect(statistic.title).to eq original_title

    MagnifierSchema.execute(mutation, context: {})

    expect(statistic.reload.title).to eq new_title
  end
end
