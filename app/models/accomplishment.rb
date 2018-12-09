# frozen_string_literal: true

class Accomplishment < ApplicationRecord
  # actions
  CREATED = 'created'
  WORKED = 'worked'
  CLOSED = 'closed'
  MERGED = 'merged'

  belongs_to :week_in_review
  belongs_to :statistic
  belongs_to :user

  validates :week_in_review_id, :statistic_id, :user_id, :type, :action, presence: true

  # TODO: Need to define business case here before enforcing this.
  # Meaning can an issue/PR appear in more than one area (i.e. same
  # issue under 'issues worked' and 'issues closed', etc.)
  #
  # validates(
  #   :statistic_id,
  #   uniqueness: {
  #     scope: :week_in_review_id,
  #     message: 'This statistic is already present in this week in review'
  #   }
  # )
end
