# frozen_string_literal: true

class Comment < ApplicationRecord
  # types
  CONCERNS = 'concerns'
  WEEK_GO  = 'week-go'
  ODDBALL  = 'oddball-team'
  PROJECT  = 'project-team'

  belongs_to :week_in_review
  belongs_to :user

  validates :body, :week_in_review_id, :type, :user_id, presence: true
  validates(
    :type,
    uniqueness: {
      scope: :week_in_review_id,
      message: 'This user already has a comment of this type for this week'
    }
  )
end
