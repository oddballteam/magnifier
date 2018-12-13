# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Queries::WeekInReviews::WeekInReviewQuery do
  let(:user) { create :user }
  let(:date) { '2018-10-11' }
  let(:github_user) { create :github_user, user_id: user.id }
  let(:hub_id) { github_user.github_id }
  let(:query) do
    <<-GRAPHQL
      query {
        weekInReview(date: "#{date}") {
          id
          statisticsMostRecentUpdatedAt
          startDate
          endDate
          userId
          employee {
            firstName
            lastName
          }
          issuesCreated {
            title
          }
          issuesWorked {
            title
          }
          issuesClosed {
            title
          }
          pullRequestsCreated {
            title
            id
          }
          pullRequestsWorked {
            title
          }
          pullRequestsMerged {
            title
          }
        }
      }
    GRAPHQL
  end

  before do
    create :statistic, :open_pr, source_created_by: hub_id
    create :statistic, :merged_pr, source_created_by: hub_id
    create :statistic, :open_issue, source_created_by: hub_id
    create :statistic, :closed_issue, source_created_by: hub_id
    create :statistic, :open_issue, assignees: [hub_id]
    create :statistic, :closed_issue, assignees: [hub_id]
  end

  context 'happy path' do
    let!(:response) { MagnifierSchema.execute(query, context: { current_user: user }) }
    let(:week_in_review) { response.dig('data', 'weekInReview') }

    it "returns the current user's WeekInReview record for the passed week", :aggregate_failures do
      expect(week_in_review).to be_present
      expect(week_in_review.dig('userId')).to eq user.id
      expect(week_in_review.dig('startDate')).to be <= date
      expect(week_in_review.dig('endDate')).to be >= date
    end

    it "returns the WeekInReview's Accomplishments", :aggregate_failures do
      expect(week_in_review.dig('issuesCreated')).to be_present
      expect(week_in_review.dig('issuesWorked')).to be_present
      expect(week_in_review.dig('issuesClosed')).to be_present
      expect(week_in_review.dig('pullRequestsCreated')).to be_present
      expect(week_in_review.dig('pullRequestsWorked')).to be_present
      expect(week_in_review.dig('pullRequestsMerged')).to be_present
    end

    it 'returns the employee details that the WeekInReview is for' do
      expect(week_in_review.dig('employee', 'firstName')).to eq user.first_name
      expect(week_in_review.dig('employee', 'lastName')).to eq user.last_name
    end

    it "returns the WeekInReview's most recently updated Statistic's sourceUpdatedAt" do
      most_recent_updated_at = Statistic.order(:source_updated_at).last.source_updated_at

      expect(week_in_review.dig('statisticsMostRecentUpdatedAt')).to eq most_recent_updated_at
    end
  end

  context 'when the current user does not have a WeekInReview for the passed date' do
    before do
      expect(user.week_in_reviews.count).to eq 0
      expect(user.accomplishments.count).to eq 0
    end

    let!(:response) { MagnifierSchema.execute(query, context: { current_user: user }) }
    let(:week_in_review) { response.dig('data', 'weekInReview') }

    it "creates and returns the week's WeekInReview", :aggregate_failures do
      expect(week_in_review.dig('userId')).to eq user.id
      expect(week_in_review.dig('startDate')).to be <= date
      expect(week_in_review.dig('endDate')).to be >= date
    end

    it "creates the WeekInReview's Accomplishments" do
      expect(user.accomplishments.count).to eq 10
    end
  end

  context 'when the current user does have a WeekInReview for the passed date' do
    let(:week_in_review) { create :week_in_review, user: user }
    let(:open_pr) { create :statistic, :open_pr, source_created_by: hub_id }
    let!(:accomplishment) do
      create(
        :accomplishment,
        :created_pr,
        week_in_review: week_in_review,
        statistic: open_pr,
        user: user
      )
    end
    let(:response) { MagnifierSchema.execute(query, context: { current_user: user }) }
    let(:returned_week_in_review) { response.dig('data', 'weekInReview') }

    it 'returns the existing WeekInReview and Accomplishments', :aggregate_failures do
      expect(returned_week_in_review.dig('id')).to eq week_in_review.id
      expect(
        returned_week_in_review.dig('pullRequestsCreated').first['id']
      ).to eq open_pr.id
    end

    it 'does not create a new WeekInReview' do
      expect(WeekInReview.count).to eq 1
    end
  end

  context 'without a logged in user' do
    it 'raises an error' do
      expect do
        MagnifierSchema.execute(query, context: {})
      end.to raise_error WeekInReviews::Error, 'Requires a logged in user'
    end
  end
end
