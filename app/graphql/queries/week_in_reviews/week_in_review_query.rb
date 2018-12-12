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

        if current_user
          find_WIR(current_user, date) || create_WIR!(current_user, date)
        else
          raise ::WeekInReviews::Error, 'Requires a logged in user'
        end
      end

      private

      def find_WIR(user, date)
        WeekInReview.for_user_and_date(user, date)
      end

      def create_WIR!(user, date)
        ::WeekInReviews::Builder.new(user, date).assemble!
      end
    end
  end
end
