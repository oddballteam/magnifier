# frozen_string_literal: true

# rubocop:disable Metrics/LineLength
# rubocop:disable Metrics/ParameterLists
module Queries
  module Statistics
    class StatisticsQuery < Queries::BaseQuery
      description 'Returns all the statistics that meet the passed criteria.'

      type [Types::StatisticType], null: false

      argument(
        :datetime,
        String,
        required: true,
        description: 'The datetime, in iso8601 format, that the Statistic records will be scoped to. For example, "2018-10-06T20:31:41Z"'
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
      argument(
        :for_week,
        Boolean,
        required: false,
        description: "If true will return statistics for the passed datetime's week only"
      )

      def resolve(datetime:, datetime_type:, github_user_id:, ownership_type:, type:, state:, for_week: false)
        stats = ::Statistic
                .load_repo_and_org
                .of_type(type)
                .of_state(state)
                .order(id: :desc)

        stats = scope_ownership_type(stats, github_user_id, ownership_type)
        stats = scope_start_time(stats, datetime, datetime_type, for_week)
        stats = scope_end_time(stats, datetime, datetime_type, for_week)
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

      def scope_start_time(stats, datetime, datetime_type, for_week)
        start_time = datetime
        start_time = ::WeekInReviews::Boundries.new(datetime).start_time if for_week.present?

        case datetime_type
        when ::Statistic::CREATED
          stats.created_after(start_time)
        when ::Statistic::UPDATED
          stats.updated_after(start_time)
        when ::Statistic::CLOSED
          stats.closed_after(start_time)
        end
      end

      def scope_end_time(stats, datetime, datetime_type, for_week)
        end_time = Time.current.iso8601
        end_time = ::WeekInReviews::Boundries.new(datetime).end_time if for_week.present?

        case datetime_type
        when ::Statistic::CREATED
          stats.created_before(end_time)
        when ::Statistic::UPDATED
          stats.updated_before(end_time)
        when ::Statistic::CLOSED
          stats.closed_before(end_time)
        end
      end
    end
  end
end
# rubocop:enable Metrics/LineLength
# rubocop:enable Metrics/ParameterLists
