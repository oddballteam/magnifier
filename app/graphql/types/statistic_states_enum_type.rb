# frozen_string_literal: true

module Types
  class StatisticStatesEnumType < BaseEnum
    description 'The state of the statistics'
    value 'OPEN', 'An open statistic', value: Statistic::OPEN
    value 'CLOSED', 'A closed statistic', value: Statistic::CLOSED
    value 'MERGED', 'A merged statistic', value: Statistic::MERGED
  end
end
