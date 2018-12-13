# frozen_string_literal: true

module Types
  class WeekInReviewType < Types::BaseObject
    field :id, Int, null: false
    field :start_date, String, null: false
    field :end_date, String, null: false
    field :user_id, Int, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false

    field :employee, UserType, null: false, description: 'The WeekInReviews user'
    field :issues_created, [StatisticType], null: true
    field :issues_worked, [StatisticType], null: true
    field :issues_closed, [StatisticType], null: true
    field :pull_requests_created, [StatisticType], null: true
    field :pull_requests_worked, [StatisticType], null: true
    field :pull_requests_merged, [StatisticType], null: true
    field(
      :statistics_most_recent_updated_at,
      String,
      null: true,
      description: 'The sourceUpdateAt for the most recently updated Statistic'
    )

    def employee
      object.user
    end

    def issues_created
      object
        .accomplishments
        .eager_load(:statistic)
        .issues
        .created
        .map(&:statistic)
    end

    def issues_worked
      object
        .accomplishments
        .eager_load(:statistic)
        .issues
        .worked
        .map(&:statistic)
    end

    def issues_closed
      object
        .accomplishments
        .eager_load(:statistic)
        .issues
        .closed
        .map(&:statistic)
    end

    def pull_requests_created
      object
        .accomplishments
        .eager_load(:statistic)
        .pull_requests
        .created
        .map(&:statistic)
    end

    def pull_requests_worked
      object
        .accomplishments
        .eager_load(:statistic)
        .pull_requests
        .worked
        .map(&:statistic)
    end

    def pull_requests_merged
      object
        .accomplishments
        .eager_load(:statistic)
        .pull_requests
        .merged
        .map(&:statistic)
    end

    def statistics_most_recent_updated_at
      object
        .statistics
        .order(source_updated_at: :asc)
        .last
        &.source_updated_at
    end
  end
end
