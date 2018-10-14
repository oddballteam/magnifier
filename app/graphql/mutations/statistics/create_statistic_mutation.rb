# frozen_string_literal: true

module Mutations
  module Statistics
    class CreateStatisticMutation < Mutations::BaseMutation
      description 'Creates a Statistic with the passed data.'
      null true

      argument :attributes, Types::StatisticAttributes, required: true

      field :statistic,
            Types::StatisticType,
            null: true,
            description: 'The statistic just added'
      field :errors, [String], null: true

      def resolve(attributes:)
        args      = attributes.to_h.symbolize_keys
        statistic = ::Statistic.create! args

        statistic_response statistic
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
