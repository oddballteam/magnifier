# frozen_string_literal: true

class GithubUser < ApplicationRecord
  has_and_belongs_to_many :statistics

  validates :github_login, presence: true, uniqueness: true
  validates :github_id, presence: true, uniqueness: true
  validates :html_url, presence: true, uniqueness: true
end
