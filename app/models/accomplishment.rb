# frozen_string_literal: true

class Accomplishment < ApplicationRecord
  # Disables single table inheritance
  # @see https://apidock.com/rails/ActiveRecord/Base/inheritance_column/class#1045-Disable-STI
  #
  self.inheritance_column = :_type_disabled

  # @see https://api.rubyonrails.org/v5.2.1/classes/ActiveRecord/Enum.html
  #
  enum action: { created: 0, worked: 1, closed: 2, merged: 3 }

  belongs_to :week_in_review
  belongs_to :statistic
  belongs_to :user

  validates :week_in_review_id, :statistic_id, :user_id, :type, :action, presence: true

  scope :issues, -> { where(type: Statistic::ISSUE) }
  scope :pull_requests, -> { where(type: Statistic::PR) }

  def self.create_created_issue!(week_in_review, statistic, user)
    issues.created.create!(
      week_in_review: week_in_review,
      statistic: statistic,
      user: user
    )
  end

  def self.create_worked_issue!(week_in_review, statistic, user)
    issues.worked.create!(
      week_in_review: week_in_review,
      statistic: statistic,
      user: user
    )
  end

  def self.create_closed_issue!(week_in_review, statistic, user)
    issues.closed.create!(
      week_in_review: week_in_review,
      statistic: statistic,
      user: user
    )
  end

  def self.create_created_pr!(week_in_review, statistic, user)
    pull_requests.created.create!(
      week_in_review: week_in_review,
      statistic: statistic,
      user: user
    )
  end

  def self.create_worked_pr!(week_in_review, statistic, user)
    pull_requests.worked.create!(
      week_in_review: week_in_review,
      statistic: statistic,
      user: user
    )
  end

  def self.create_merged_pr!(week_in_review, statistic, user)
    pull_requests.merged.create!(
      week_in_review: week_in_review,
      statistic: statistic,
      user: user
    )
  end
end
