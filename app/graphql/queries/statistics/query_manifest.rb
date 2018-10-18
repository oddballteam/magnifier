# frozen_string_literal: true

require_relative 'all_statistics_query'
require_relative 'statistic_query'

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
        field :all_statistics, resolver: Queries::Statistics::AllStatisticsQuery
        field :statistic, resolver: Queries::Statistics::StatisticQuery
      end
    end
  end
end
