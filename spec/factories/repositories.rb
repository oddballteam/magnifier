# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    sequence(:name, 100) { |n| "repository-#{n}" }
    sequence(:url, 100) { |n| "https://github.com/organization/repository-#{n}" }
    organization
  end
end
