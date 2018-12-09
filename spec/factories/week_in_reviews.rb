# frozen_string_literal: true

FactoryBot.define do
  factory :week_in_review do
    start_date { '2018-11-26' }
    end_date { '2018-12-02' }
    user
  end
end
