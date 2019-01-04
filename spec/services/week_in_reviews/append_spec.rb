# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeekInReviews::Append do
  describe '.#new_accomplishments!' do
    let(:dec_10th) { '2018-12-10' }
    let(:dec_16th) { '2018-12-16' }
    let(:during_week_in_review) { '2018-12-12T10:31:41Z' }
    let(:before_week_in_review) { '2018-10-12T10:31:41Z' }
    let(:user) { create :user }
    let(:github_user) { create :github_user, user_id: user.id }
    let(:week_in_review) do
      create(
        :week_in_review,
        user: user,
        start_date: dec_10th,
        end_date: dec_16th
      )
    end

    it 'returns an array of the created Accomplishment records', :aggregate_failures do
      statistic = create(
        :statistic,
        :closed_issue,
        source_created_at: before_week_in_review,
        source_updated_at: during_week_in_review,
        source_closed_at: during_week_in_review
      )

      results = WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

      expect(results.class).to eq Array
      expect(results.map(&:class).uniq).to eq [Accomplishment]
    end

    context 'when the initialized Statistic is an issue' do
      context 'and it was created (by someone else), updated and closed during the WeekInReview in question' do
        let(:statistic) do
          create(
            :statistic,
            :closed_issue,
            source_created_at: during_week_in_review,
            source_updated_at: during_week_in_review,
            source_closed_at: during_week_in_review
          )
        end

        it 'should create an issue worked and issue closed Accomplishments', :aggregate_failures do
          expect(user.accomplishments.count).to eq 0

          WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

          expect(user.accomplishments.count).to eq 2
          expect(user.accomplishments.pluck(:type).uniq).to eq [Statistic::ISSUE]
          expect(user.accomplishments.pluck(:action)).to include 'worked', 'closed'
          expect(user.accomplishments.pluck(:user_id).uniq).to eq [user.id]
          expect(user.accomplishments.pluck(:statistic_id).uniq).to eq [statistic.id]
          expect(user.accomplishments.pluck(:week_in_review_id).uniq).to eq [week_in_review.id]
        end
      end

      context 'and it was created by the user, and updated during the WeekInReview in question' do
        let(:statistic) do
          create(
            :statistic,
            :open_issue,
            source_created_by: github_user.github_id,
            source_created_at: during_week_in_review,
            source_updated_at: during_week_in_review
          )
        end

        it 'should create an issue created and issue worked Accomplishments', :aggregate_failures do
          expect(user.accomplishments.count).to eq 0

          WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

          expect(user.accomplishments.count).to eq 2
          expect(user.accomplishments.pluck(:type).uniq).to eq [Statistic::ISSUE]
          expect(user.accomplishments.pluck(:action)).to include 'worked', 'created'
          expect(user.accomplishments.pluck(:user_id).uniq).to eq [user.id]
          expect(user.accomplishments.pluck(:statistic_id).uniq).to eq [statistic.id]
          expect(user.accomplishments.pluck(:week_in_review_id).uniq).to eq [week_in_review.id]
        end
      end

      context 'and it was updated during the WeekInReview in question' do
        let(:statistic) do
          create(
            :statistic,
            :open_issue,
            source_created_at: during_week_in_review,
            source_updated_at: during_week_in_review
          )
        end

        it 'should create an issue worked Accomplishments', :aggregate_failures do
          expect(user.accomplishments.count).to eq 0

          WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

          expect(user.accomplishments.count).to eq 1
          expect(user.accomplishments.pluck(:type).uniq).to eq [Statistic::ISSUE]
          expect(user.accomplishments.pluck(:action)).to include 'worked'
          expect(user.accomplishments.pluck(:user_id).uniq).to eq [user.id]
          expect(user.accomplishments.pluck(:statistic_id).uniq).to eq [statistic.id]
          expect(user.accomplishments.pluck(:week_in_review_id).uniq).to eq [week_in_review.id]
        end
      end
    end

    context 'when the initialized Statistic is a pull request' do
      context 'and it was updated and merged during the WeekInReview in question' do
        let(:statistic) do
          create(
            :statistic,
            :merged_pr,
            source_created_at: before_week_in_review,
            source_updated_at: during_week_in_review,
            source_closed_at: during_week_in_review
          )
        end

        it 'should create a PR worked and PR merged Accomplishments', :aggregate_failures do
          expect(user.accomplishments.count).to eq 0

          WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

          expect(user.accomplishments.count).to eq 2
          expect(user.accomplishments.pluck(:type).uniq).to eq [Statistic::PR]
          expect(user.accomplishments.pluck(:action)).to include 'worked', 'merged'
          expect(user.accomplishments.pluck(:user_id).uniq).to eq [user.id]
          expect(user.accomplishments.pluck(:statistic_id).uniq).to eq [statistic.id]
          expect(user.accomplishments.pluck(:week_in_review_id).uniq).to eq [week_in_review.id]
        end
      end

      context 'and it was created and updated during the WeekInReview in question' do
        let(:statistic) do
          create(
            :statistic,
            :open_pr,
            source_created_at: during_week_in_review,
            source_updated_at: during_week_in_review
          )
        end

        it 'should create a PR worked and PR merged Accomplishments', :aggregate_failures do
          expect(user.accomplishments.count).to eq 0

          WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

          expect(user.accomplishments.count).to eq 2
          expect(user.accomplishments.pluck(:type).uniq).to eq [Statistic::PR]
          expect(user.accomplishments.pluck(:action)).to include 'worked', 'created'
          expect(user.accomplishments.pluck(:user_id).uniq).to eq [user.id]
          expect(user.accomplishments.pluck(:statistic_id).uniq).to eq [statistic.id]
          expect(user.accomplishments.pluck(:week_in_review_id).uniq).to eq [week_in_review.id]
        end
      end

      context 'and it was created and closed during the WeekInReview in question' do
        let(:statistic) do
          create(
            :statistic,
            :closed_pr,
            source_created_at: during_week_in_review,
            source_updated_at: during_week_in_review,
            source_closed_at: during_week_in_review
          )
        end

        it 'should create a PR created and PR worked Accomplishments', :aggregate_failures do
          expect(user.accomplishments.count).to eq 0

          WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

          expect(user.accomplishments.count).to eq 2
          expect(user.accomplishments.pluck(:type).uniq).to eq [Statistic::PR]
          expect(user.accomplishments.pluck(:action)).to include 'worked', 'created'
          expect(user.accomplishments.pluck(:user_id).uniq).to eq [user.id]
          expect(user.accomplishments.pluck(:statistic_id).uniq).to eq [statistic.id]
          expect(user.accomplishments.pluck(:week_in_review_id).uniq).to eq [week_in_review.id]
        end
      end

      context 'and it was created, worked and merged during the WeekInReview in question' do
        let(:statistic) do
          create(
            :statistic,
            :merged_pr,
            source_created_at: during_week_in_review,
            source_updated_at: during_week_in_review,
            source_closed_at: during_week_in_review
          )
        end

        it 'should create a PR created, PR worked, and PR merged Accomplishments', :aggregate_failures do
          expect(user.accomplishments.count).to eq 0

          WeekInReviews::Append.new(statistic, week_in_review, user).new_accomplishments!

          expect(user.accomplishments.count).to eq 3
          expect(user.accomplishments.pluck(:type).uniq).to eq [Statistic::PR]
          expect(user.accomplishments.pluck(:action)).to include 'worked', 'created', 'merged'
          expect(user.accomplishments.pluck(:user_id).uniq).to eq [user.id]
          expect(user.accomplishments.pluck(:statistic_id).uniq).to eq [statistic.id]
          expect(user.accomplishments.pluck(:week_in_review_id).uniq).to eq [week_in_review.id]
        end
      end
    end
  end
end
