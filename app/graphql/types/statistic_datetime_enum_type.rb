# frozen_string_literal: true

module Types
  class StatisticDatetimeEnumType < BaseEnum
    description 'During a query, defines the datetime attribute the statistics will be scoped to.'
    value(
      'CREATED',
      'Statistics created after the passed datetime',
      value: Statistic::CREATED
    )
    value(
      'UPDATED',
      'Statistics updated after the passed datetime',
      value: Statistic::UPDATED
    )
    value(
      'CLOSED',
      'Statistics closed after the passed datetime',
      value: Statistic::CLOSED
    )
  end
end
