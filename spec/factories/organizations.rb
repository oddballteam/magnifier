FactoryBot.define do
  factory :organization do
    sequence(:name, 100) { |n| "organization-#{n}" }
    sequence(:url, 100) { |n| "https://github.com/organization-#{n}" }
  end
end
