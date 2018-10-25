# frozen_string_literal: true

# Class to represent an organization from GitHub's API.
#
# @see https://developer.github.com/v3/orgs/
#
class Organization < ApplicationRecord
  has_many :statistics
  has_many :repositories
  has_many :users

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
end
