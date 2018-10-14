# frozen_string_literal: true

module Mutations
  module Statistics
    class UpdateStatisticMutation < Mutations::BaseMutation
      description 'Updates a Statistic with the passed data.'
      null true

      argument :attributes, Types::StatisticAttributes, required: true
      argument :id, ID, required: true

      field :statistic,
            Types::StatisticType,
            null: true,
            description: 'The statistic just added'
      field :errors, [String], null: true

      def resolve(attributes:, id:)
        args      = attributes.to_h.symbolize_keys
        statistic = ::Statistic.find_by id: id.to_i

        statistic.update! args
        statistic_response statistic.reload
      rescue ActiveRecord::RecordInvalid => e
        statistic_response(nil, e.record.errors.full_messages)
      end

      private

      def statistic_response(statistic, error_messages = [])
        {
          statistic: statistic,
          errors: error_messages
        }
      end
    end
  end
end
