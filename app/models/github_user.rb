# frozen_string_literal: true

# Class to capture the salient attributes of the user in
# GitHub's API responses
#
# @see the user portion of the response in
# https://developer.github.com/v3/search/#search-issues
#
class GithubUser < ApplicationRecord
  has_and_belongs_to_many :statistics

  validates :github_login, presence: true, uniqueness: true
  validates :github_id, presence: true, uniqueness: true
  validates :html_url, presence: true, uniqueness: true
end
