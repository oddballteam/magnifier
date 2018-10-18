# frozen_string_literal: true

module Queries
  module Statistics
    # Query class that fetches all Statistics in the db
    #
    class StatisticsQuery < Queries::BaseQuery
      description 'All statistics.'

      type [Types::StatisticType], null: false
      argument :limit, Integer, required: false

      def resolve(limit: nil)
        ::Statistic.order(id: :asc).limit(limit)
      end
    end
  end
end
