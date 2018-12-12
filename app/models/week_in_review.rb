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

  scope :for_user, ->(user_id) { where(user_id: user_id) }

  def self.for_date(date)
    where('start_date <= ? AND end_date >= ?', date, date)
  end

  def self.for_user_and_date(user, date)
    WeekInReview
      .for_user(user.id)
      .for_date(date)
      .first
  end
end
