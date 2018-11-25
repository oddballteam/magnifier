# frozen_string_literal: true

module Types
  class StatisticOwnershipEnumType < BaseEnum
    description 'During a query, defines the relationship between the Statistic and associated GithubUser.  Whether the user created the statistic, or is assigned to it.'
    value 'ASSIGNED', 'GithubUser is assigned to the statistic', value: Statistic::ASSIGNED
    value 'CREATED', 'GithubUser created the statistic', value: Statistic::CREATED
  end
end
