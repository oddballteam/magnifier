# frozen_string_literal: true

# Class to represent a repository from GitHub's API.
#
# @see https://developer.github.com/v3/repos/
#
class Repository < ApplicationRecord
  belongs_to :organization

  validates :name, :organization_id, presence: true
  validates :url, presence: true, uniqueness: true
end
