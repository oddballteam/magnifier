# frozen_string_literal: true

module Types
  class AccomplishmentType < Types::BaseObject
    field :id, Int, null: false
    field :week_in_review, Types::WeekInReviewType, null: false
    field :statistic, Types::StatisticType, null: false
    field :user, Types::UserType, null: false
    field :type, String, null: false
    field :action, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end
