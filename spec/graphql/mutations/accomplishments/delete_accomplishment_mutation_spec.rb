# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Accomplishments::DeleteAccomplishmentMutation do
  let(:user) { create :user }
  let(:hub_id) { create(:github_user, user_id: user.id).github_id }
  let(:statistic) { create :statistic, :open_issue, assignees: [hub_id] }
  let(:week_in_review) { create :week_in_review, user: user }
  let!(:accomplishment) do
    create(
      :accomplishment,
      week_in_review: week_in_review,
      statistic: statistic,
      user: user
    )
  end
  let(:mutation) do
    <<-GRAPHQL
      mutation {
        deleteAccomplishment(
          statisticId: #{statistic.id},
          weekInReviewId: #{week_in_review.id}
        ) {
          deleted
          errors
        }
      }
    GRAPHQL
  end

  it 'deletes the Accomplishment record based on the passed args' do
    expect do
      MagnifierSchema.execute(mutation, context: {})
    end.to change { Accomplishment.count }.from(1).to(0)
  end

  it 'does not delete the associated Statistic' do
    MagnifierSchema.execute(mutation, context: {})

    expect(statistic).to be_present
  end

  it 'does not delete the associated WeekInReview' do
    MagnifierSchema.execute(mutation, context: {})

    expect(week_in_review).to be_present
  end

  it 'yields the expected response shape and values' do
    expected_response = {
      "deleteAccomplishment" => {
        "deleted" => true,
        "errors" => []
      }
    }

    response = MagnifierSchema.execute(mutation, context: {})

    expect(response['data']).to eq expected_response
  end

  it 'does not yield any errors' do
    response = MagnifierSchema.execute(mutation, context: {})
    errors   = response.dig('data', 'deleteAccomplishment', 'errors')

    expect(errors).to_not be_present
  end

  context 'when the passed Accomplishment does not exist' do
    before { Accomplishment.delete_all }

    it 'responds the deleted: false' do
      response = MagnifierSchema.execute(mutation, context: {})
      deleted  = response.dig('data', 'deleteAccomplishment', 'deleted')

      expect(deleted).to eq false
    end

    it 'responds the errors present' do
      response = MagnifierSchema.execute(mutation, context: {})
      errors   = response.dig('data', 'deleteAccomplishment', 'errors')

      expect(errors).to be_present
    end
  end
end
