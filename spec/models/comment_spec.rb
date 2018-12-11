# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      comment = create :comment

      expect(comment).to be_valid
    end

    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:week_in_review_id) }
    it { should validate_presence_of(:user_id) }

    context 'there can only be one type of comment per week_in_review_id' do
      it 'raises an error if a duplicate is created', :aggregate_failures do
        user = create :user
        wir  = create :week_in_review, user: user

        comment1 = create :comment, week_in_review: wir, type: :oddball_team, user: user
        comment2 = create :comment, week_in_review: wir, type: :project_team, user: user

        expect(comment1).to be_valid
        expect(comment2).to be_valid

        expect do
          create :comment, week_in_review: wir, type: :oddball_team, user: user
        end.to raise_error(
          ActiveRecord::RecordInvalid,
          'Validation failed: Type This user already has a comment of this type for this week'
        )
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:week_in_review) }
    it { should belong_to(:user) }
  end
end
