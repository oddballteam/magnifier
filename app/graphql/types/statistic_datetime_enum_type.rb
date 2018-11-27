# frozen_string_literal: true

module Types
  class StatisticDatetimeEnumType < BaseEnum
    description 'During a query, defines the datetime attribute the statistics will be scoped to.'
    value(
      'CREATED_AFTER',
      'Statistics created after the passed datetime',
      value: Statistic::CREATED_AFTER
    )
    value(
      'UPDATED_AFTER',
      'Statistics updated after the passed datetime',
      value: Statistic::UPDATED_AFTER
    )
    value(
      'CLOSED_AFTER',
      'Statistics closed after the passed datetime',
      value: Statistic::CLOSED_AFTER
    )
  end
end
