# frozen_string_literal: true

FactoryBot.define do
  factory :statistic do
    sequence(:source_id, 1000, &:to_s)
    source_type { Statistic::PR }
    source { Statistic::GITHUB }
    state { Statistic::OPEN }
    organization
    sequence(:url, 100) { |n| "https://github.com/organization/repository/pulls/#{n}" }
    title { 'Some title' }
    sequence(:source_created_at, 10) { |n| "2018-10-08T#{n}:31:41Z" }
  end
end
