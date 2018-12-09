# frozen_string_literal: true

FactoryBot.define do
  factory :accomplishment do
    week_in_review
    statistic { FactoryBot.create(:statistic, :open_issue) }
    user
    type { Statistic::ISSUE }
    action { Accomplishment::WORKED }
  end
end
