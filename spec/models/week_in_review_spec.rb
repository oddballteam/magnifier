# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeekInReview, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      week_in_review = create :week_in_review

      expect(week_in_review).to be_valid
    end

    it { should validate_presence_of(:start_date) }
    it { should validate_presence_of(:end_date) }
    it { should validate_presence_of(:user_id) }

    context 'there can only be one week in review per user, per week' do
      it 'raises an error if a duplicate week in review is created', :aggregate_failures do
        start_date = '2018-11-26'
        john = create :user
        mary = create :user
        john_week_in_review = create :week_in_review, user: john, start_date: start_date
        mary_week_in_review = create :week_in_review, user: mary, start_date: start_date

        expect(john_week_in_review).to be_valid
        expect(mary_week_in_review).to be_valid

        expect { create :week_in_review, user: john, start_date: start_date }.to raise_error(
          ActiveRecord::RecordInvalid,
          'Validation failed: Start date This user already has a week in review for this week'
        )
      end
    end
  end

  describe 'associations' do
    it { should have_many(:accomplishments) }
    it { should have_many(:statistics) }
    it { should have_many(:comments) }
    it { should belong_to(:user) }
  end
end
