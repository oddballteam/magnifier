# frozen_string_literal: true

module Queries
  module Statistics
    # Module that:
    #   - lists all of the Statistic queries
    #   - assigns a field name to each query
    #   - maps a given field name to a resolver
    #
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :statistic, resolver: Queries::Statistics::StatisticQuery
        field :statistics, resolver: Queries::Statistics::StatisticsQuery
      end
    end
  end
end
