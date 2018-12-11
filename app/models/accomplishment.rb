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

end
