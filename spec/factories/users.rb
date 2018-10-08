FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Jack_#{n}" }
    sequence(:last_name) { |n| "Smith_#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    sequence(:git_hub_username) { |n| "Jack_Smith_#{n}" }
  end
end
