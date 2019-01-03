# frozen_string_literal: true

class Comment < ApplicationRecord
  # Disables single table inheritance
  # @see https://apidock.com/rails/ActiveRecord/Base/inheritance_column/class#1045-Disable-STI
  #
  self.inheritance_column = :_type_disabled

  # @see https://api.rubyonrails.org/v5.2.1/classes/ActiveRecord/Enum.html
  #
  enum type: { concerns: 0, oddball_team: 1, project_team: 2, week_go: 3 }

  before_validation :strip_body

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

  private

  def strip_body
    self.body = body&.strip
  end
end
