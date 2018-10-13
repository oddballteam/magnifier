# frozen_string_literal: true

module Types
  module QueryTypes
    module Statistic
      include GraphQL::Schema::Member::GraphQLTypeNames

      def self.included(child_class)
        child_class.field :all_statistics,
              [StatisticType, null: true],
              description: 'All statistics',
              null: false do

          argument :limit,
                   Integer,
                   required: false
        end

        child_class.field :statistic, StatisticType, null: true do
          description 'Statistic for the passed ID'
          argument :source_id, String, required: true
        end
      end

      def all_statistics(limit=nil)
        amount = limit&.dig(:limit)

        ::Statistic.order(id: :asc).limit(amount)
      end

      def statistic(source_id)
        ::Statistic.find_by(source_id: source_id.dig(:source_id))
      end
    end
  end
end
