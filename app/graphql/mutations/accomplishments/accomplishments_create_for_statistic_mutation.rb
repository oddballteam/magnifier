# frozen_string_literal: true

module Mutations
  module Accomplishments
    class AccomplishmentsCreateForStatisticMutation < Mutations::BaseMutation
      description 'Creates/associates the Statistic and Accomplishments for the passed GitHub URL and WeekInReview.'
      null true

      argument :github_url, String, required: true
      argument :week_in_review_id, Integer, required: true

      field :accomplishments,
            [Types::AccomplishmentType],
            null: true,
            description: 'The accomplishments just added'
      field :statistic,
            Types::StatisticType,
            null: true,
            description: 'The statistic just added'
      field :errors, Types::ErrorType, null: true

      def resolve(github_url:, week_in_review_id:)
        raise ::WeekInReviews::Error, 'Requires a logged in user' if context[:current_user].blank?

        week_in_review  = find_week_in_review(week_in_review_id)
        current_user    = context[:current_user]
        statistic       = find_or_create_statistic!(current_user, github_url)
        accomplishments = create_accomplishments!(statistic, week_in_review, current_user)

        accomplishments_response(accomplishments, statistic)
      rescue ActiveRecord::RecordInvalid => e
        record_invalid_response(accomplishments, statistic, e)
      rescue StandardError => e
        error_response(accomplishments, statistic, e)
      end

      private

      def find_week_in_review(week_in_review_id)
        WeekInReview.find_by(id: week_in_review_id)
      end

      def find_or_create_statistic!(current_user, github_url)
        github_url = github_url.strip

        find_statistic(github_url) || create_statistic!(current_user, github_url)
      end

      def find_statistic(github_url)
        Statistic.find_by(url: github_url)
      end

      def create_statistic!(current_user, github_url)
        source_type = derive_source_type_from(github_url)

        Github::Persist.new(
          current_user,
          github_url: github_url
        ).send("#{source_type}!")
      end

      def derive_source_type_from(github_url)
        github_url.include?('/issues/') ? Statistic::ISSUE : Statistic::PR
      end

      def create_accomplishments!(statistic, week_in_review, current_user)
        WeekInReviews::Append.new(
          statistic,
          week_in_review,
          current_user
        ).new_accomplishments!
      end

      def accomplishments_response(accomplishments, statistic, error_message = nil)
        {
          accomplishments: accomplishments,
          statistic: statistic,
          errors: error_message
        }
      end

      # rubocop:disable Style/BracesAroundHashParameters
      def record_invalid_response(accomplishments, statistic, error)
        accomplishments_response(
          accomplishments.presence,
          statistic.presence,
          { type: error.class, message: error.record.errors.full_messages.join(', ') }
        )
      end

      def error_response(accomplishments, statistic, error)
        accomplishments_response(
          accomplishments.presence,
          statistic.presence,
          { type: error.class, message: [error.message] }
        )
      end
      # rubocop:enable Style/BracesAroundHashParameters
    end
  end
end
