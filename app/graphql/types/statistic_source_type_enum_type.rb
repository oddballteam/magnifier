# frozen_string_literal: true

module Types
  class StatisticSourceTypeEnumType < BaseEnum
    description 'The source type of the statistics'
    value 'ISSUE', 'An issue', value: Statistic::ISSUE
    value 'PR', 'A pull request', value: Statistic::PR
  end
end
