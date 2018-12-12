# frozen_string_literal: true

FactoryBot.define do
  factory :accomplishment do
    week_in_review
    statistic { FactoryBot.create(:statistic, :open_issue) }
    user
    type { Statistic::ISSUE }
    action { :created }

    trait :created_pr do
      type { Statistic::PR }
    end
  end
end
