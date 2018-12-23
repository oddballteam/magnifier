# frozen_string_literal: true

module Mutations
  module Accomplishments
    class DeleteAccomplishmentMutation < Mutations::BaseMutation
      description 'Deletes the Accomplishment with the passed data.'
      null true

      argument :statistic_id, Integer, required: true
      argument :week_in_review_id, Integer, required: true

      field :success, Boolean, null: true
      field :errors, [String], null: true

      def resolve(statistic_id:, week_in_review_id:)
        accomplishment = fetch_accomplishment(statistic_id, week_in_review_id)

        return accomplishment_response(false, ['Could not find that accomplishment']) if accomplishment.blank?

        response = accomplishment.delete

        if response.class == Accomplishment
          accomplishment_response
        else
          accomplishment_response(false, ['Could not delete the accomplishment'])
        end
      end

      private

      def fetch_accomplishment(statistic_id, week_in_review_id)
        Accomplishment.find_by(
          statistic_id: statistic_id,
          week_in_review_id: week_in_review_id
        )
      end

      def accomplishment_response(success = true, error_messages = [])
        {
          success: success,
          errors: error_messages
        }
      end
    end
  end
end
