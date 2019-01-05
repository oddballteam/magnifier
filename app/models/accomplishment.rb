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

  def self.create_created_issue!(week_in_review_id, statistic_id, user_id)
    issues.created.find_or_create_by!(
      week_in_review_id: week_in_review_id,
      statistic_id: statistic_id,
      user_id: user_id
    )
  end

  def self.create_worked_issue!(week_in_review_id, statistic_id, user_id)
    issues.worked.find_or_create_by!(
      week_in_review_id: week_in_review_id,
      statistic_id: statistic_id,
      user_id: user_id
    )
  end

  def self.create_closed_issue!(week_in_review_id, statistic_id, user_id)
    issues.closed.find_or_create_by!(
      week_in_review_id: week_in_review_id,
      statistic_id: statistic_id,
      user_id: user_id
    )
  end

  def self.create_created_pr!(week_in_review_id, statistic_id, user_id)
    pull_requests.created.find_or_create_by!(
      week_in_review_id: week_in_review_id,
      statistic_id: statistic_id,
      user_id: user_id
    )
  end

  def self.create_worked_pr!(week_in_review_id, statistic_id, user_id)
    pull_requests.worked.find_or_create_by!(
      week_in_review_id: week_in_review_id,
      statistic_id: statistic_id,
      user_id: user_id
    )
  end

  def self.create_merged_pr!(week_in_review_id, statistic_id, user_id)
    pull_requests.merged.find_or_create_by!(
      week_in_review_id: week_in_review_id,
      statistic_id: statistic_id,
      user_id: user_id
    )
  end
end
