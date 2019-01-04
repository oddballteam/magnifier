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

    trait :with_assignees do
      assignees { [FactoryBot.create(:github_user).github_id, FactoryBot.create(:github_user).github_id] }
    end

    trait :with_creator do
      source_created_by { FactoryBot.create(:github_user).github_id }
    end

    trait :open_pr do
      source_type { Statistic::PR }
      state { Statistic::OPEN }
    end

    trait :closed_pr do
      source_type { Statistic::PR }
      state { Statistic::CLOSED }
    end

    trait :merged_pr do
      source_type { Statistic::PR }
      state { Statistic::MERGED }
      sequence(:source_closed_at, 10) { |n| "2018-10-10T#{n}:31:41Z" }
    end

    trait :open_issue do
      source_type { Statistic::ISSUE }
    end

    trait :closed_issue do
      source_type { Statistic::ISSUE }
      state { Statistic::CLOSED }
      sequence(:source_closed_at, 10) { |n| "2018-10-10T#{n}:31:41Z" }
    end
  end
end
