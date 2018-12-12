# frozen_string_literal: true

module Queries
  module WeekInReviews
    class WeekInReviewQuery < Queries::BaseQuery
      description 'The WeekInReview for the current user and passed date.'

      type Types::WeekInReviewType, null: false
      argument(
        :date,
        String,
        required: true,
        description: 'Date that falls in the desired WeekInReview.  Format is "YYYY-MM-DD"'
      )

      def resolve(date:)
        current_user = context[:current_user]

        raise ::WeekInReviews::Error, 'Requires a logged in user' if current_user.blank?

        find_week_in_review(current_user, date) || create_week_in_review!(current_user, date)
      end

      private

      def find_week_in_review(user, date)
        WeekInReview.for_user_and_date(user, date)
      end

      def create_week_in_review!(user, date)
        ::WeekInReviews::Builder.new(user, date).assemble!
      end
    end
  end
end
