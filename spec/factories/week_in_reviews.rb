# frozen_string_literal: true

FactoryBot.define do
  factory :week_in_review do
    start_date { '2018-10-08' }
    end_date { '2018-10-14' }
    user
  end
end
