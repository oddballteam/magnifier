# frozen_string_literal: true

class Comment < ApplicationRecord
  # @see https://api.rubyonrails.org/v5.2.1/classes/ActiveRecord/Enum.html
  #
  enum type: { concerns: 0, oddball_team: 1, project_team: 2, week_go: 3 }

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
