# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    week_in_review
    user
    body { 'Some comment' }
    type { :concerns }
  end
end
