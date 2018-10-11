# frozen_string_literal: true

FactoryBot.define do
  factory :github_user do
    sequence(:github_login, 100) { |n| "login_#{n}" }
    sequence(:github_id, 1000) { |n| n.to_s }
    sequence(:html_url, 100) { |n| "https://github.com/user-#{n}" }
    oddball_employee { true }
  end
end
