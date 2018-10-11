# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Jack_#{n}" }
    sequence(:last_name) { |n| "Smith_#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:github_username, 100) { |n| "Jack_Smith_#{n}" }
  end
end
