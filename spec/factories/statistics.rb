# frozen_string_literal: true

FactoryBot.define do
  factory :statistic do
    sequence(:source_id, 1000, &:to_s)
    source_type { Statistic::PR }
    source { Statistic::GITHUB }
    state { Statistic::OPEN }
    repository
    organization_id { Repository.first.organization_id }
    sequence(:url, 100) { |n| "https://github.com/organization/repository/pulls/#{n}" }
    title { 'Some title' }
    sequence(:source_created_at, 10) { |n| "2018-10-08T#{n}:31:41Z" }
    sequence(:source_updated_at, 10) { |n| "2018-10-09T#{n}:31:41Z" }
    sequence(:source_created_by, 1000)
  end
end
