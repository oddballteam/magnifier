# frozen_string_literal: true

module Queries
  module Statistics
    class StatisticsQuery < Queries::BaseQuery
      description 'Returns all the statistics that meet the passed criteria.'

      type [Types::StatisticType], null: false

      argument(
        :datetime,
        String,
        required: true,
        description: 'The datetime, in iso8601 format, that the Statistic records will be scoped to. For example, "2018-10-06T20:31:41Z"',
      )
      argument(
        :datetime_type,
        Types::StatisticDatetimeEnumType,
        required: true,
        description: 'Enum of choices that will define the datetime attribute the statistics will be scoped to.'
      )
      argument(
        :github_user_id,
        Integer,
        required: true,
        description: 'The GithubUser#github_id that the Statistics are scoped to.'
      )
      argument(
        :ownership_type,
        Types::StatisticOwnershipEnumType,
        required: true,
        description: 'Enum of choices that define the relationship between the Statistic and associated GithubUser.'
      )
      argument(
        :state,
        [Types::StatisticStatesEnumType],
        required: true,
        description: 'The Statistic#state'
      )
      argument(
        :type,
        [Types::StatisticSourceTypeEnumType],
        required: true,
        description: 'The Statistic#source_type'
      )

      def resolve(datetime:, datetime_type:, github_user_id:, ownership_type:, type:, state:)
        stats = ::Statistic
          .load_repo_and_org
          .of_type(type)
          .of_state(state)
          .order(id: :desc)

        stats = scope_ownership_type(stats, github_user_id, ownership_type)
        stats = scope_datetime_type(stats, datetime, datetime_type)
        stats
      end

      private

      def scope_ownership_type(stats, github_user_id, ownership_type)
        case ownership_type
        when ::Statistic::ASSIGNED
          stats.assigned_to(github_user_id)
        when ::Statistic::CREATED
          stats.created_by(github_user_id)
        end
      end

      def scope_datetime_type(stats, datetime, datetime_type)
        case datetime_type
        when ::Statistic::CREATED_AFTER
          stats.created_after(datetime)
        when ::Statistic::UPDATED_AFTER
          stats.updated_after(datetime)
        when ::Statistic::CLOSED_AFTER
          stats.closed_after(datetime)
        end
      end
    end
  end
end
