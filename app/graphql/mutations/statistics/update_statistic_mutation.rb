# frozen_string_literal: true

module Mutations
  module Statistics
    # Mutation class that updates an existing Statistic in the db
    #
    class UpdateStatisticMutation < Mutations::BaseMutation
      description 'Updates a Statistic with the passed data.'
      null true

      argument :attributes, Types::StatisticInput, required: true
      argument :id, Integer, required: true

      field :statistic,
            Types::StatisticType,
            null: true,
            description: 'The statistic just added'
      field :errors, [String], null: true

      def resolve(attributes:, id:)
        statistic = ::Statistic.find_by id: id

        if statistic.present?
          statistic.update! args_for(attributes)
          statistic_response statistic.reload
        else
          statistic_response nil, ["Statistic with id #{id} does not exist"]
        end
      rescue ActiveRecord::RecordInvalid => e
        statistic_response nil, e.record.errors.full_messages
      end

      private

      def args_for(attributes)
        attributes.to_h.symbolize_keys
      end

      def statistic_response(statistic, error_messages = [])
        {
          statistic: statistic,
          errors: error_messages
        }
      end
    end
  end
end
