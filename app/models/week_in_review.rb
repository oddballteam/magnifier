# frozen_string_literal: true

class WeekInReview < ApplicationRecord
  has_many :accomplishments
  has_many :statistics, through: :accomplishments
  has_many :comments
  belongs_to :user

  validates :start_date, :end_date, :user_id, presence: true
  validates(
    :start_date,
    uniqueness: {
      scope: :user_id,
      message: 'This user already has a week in review for this week'
    }
  )
end
