# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeekInReviews::Builder do
  let(:user) { create :user }
  let(:date) { '2018-10-11' }
  let(:github_user) { create :github_user, user_id: user.id }
  let(:hub_id) { github_user.github_id }

  describe '.initialize' do
    it 'raises an error if an invalid date format is passed' do
      invalid_date = Date.today

      expect { WeekInReviews::Builder.new(user, invalid_date) }.to raise_error(
        WeekInReviews::Error,
        'Date must be a string'
      )
    end

    it 'raises an error if the passed User does not have a GithubUser record' do
      invalid_user = create :user

      expect { WeekInReviews::Builder.new(invalid_user, date) }.to raise_error(
        WeekInReviews::Error,
        'User does not have a GithubUser record'
      )
    end
  end

  describe '#assemble!' do
    before do
      create :statistic, :open_pr, source_created_by: hub_id
      create :statistic, :merged_pr, source_created_by: hub_id
      create :statistic, :open_issue, source_created_by: hub_id
      create :statistic, :closed_issue, source_created_by: hub_id
      create :statistic, :open_issue, assignees: [hub_id]
      create :statistic, :closed_issue, assignees: [hub_id]
    end

    it 'creates a WeekInReview record for the passed user' do
      expect { WeekInReviews::Builder.new(user, date).assemble! }.to change {
        user.week_in_reviews.count
      }.from(0).to(1)
    end

    it 'sets the WeekInReview#start_date to the Monday of the passed week', :aggregate_failures do
      week_in_review = WeekInReviews::Builder.new(user, date).assemble!

      expect(week_in_review.start_date.monday?).to eq true
      expect(week_in_review.start_date.to_s).to eq '2018-10-08'
    end

    it 'sets the WeekInReview#end_date to the Sunday of the passed week', :aggregate_failures do
      week_in_review = WeekInReviews::Builder.new(user, date).assemble!

      expect(week_in_review.end_date.sunday?).to eq true
      expect(week_in_review.end_date.to_s).to eq '2018-10-14'
    end

    it 'creates the expected Accomplishment records for the created WeekInReview', :aggregate_failures do
      week_in_review = WeekInReviews::Builder.new(user, date).assemble!

      expect(week_in_review.accomplishments.issues.created.count).to eq 2
      expect(week_in_review.accomplishments.issues.worked.count).to eq 2
      expect(week_in_review.accomplishments.issues.closed.count).to eq 1
      expect(week_in_review.accomplishments.pull_requests.created.count).to eq 2
      expect(week_in_review.accomplishments.pull_requests.worked.count).to eq 2
      expect(week_in_review.accomplishments.pull_requests.merged.count).to eq 1
    end
  end
end
