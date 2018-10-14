# frozen_string_literal: true

require_relative 'all_statistics_query'
require_relative 'statistic_query'

module Queries
  module Statistics
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :all_statistics, resolver: Queries::Statistics::AllStatisticsQuery
        field :statistic, resolver: Queries::Statistics::StatisticQuery
      end
    end
  end
end
