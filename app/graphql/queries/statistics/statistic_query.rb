# frozen_string_literal: true

module Queries
  module Statistics
    class StatisticQuery < Queries::BaseQuery
      description 'The statistic with the passed criteria.'

      type Types::StatisticType, null: false
      argument :id, ID, required: false
      argument :source_id, String, required: false

      def resolve(id: nil, source_id: nil)
        if id
          ::Statistic.find_by id: id
        else
          ::Statistic.find_by source_id: source_id
        end
      end
    end
  end
end
