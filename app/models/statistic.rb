# frozen_string_literal: true

class Statistic < ApplicationRecord
  # source_types
  ISSUE = 'issue'
  PR = 'pull_request'

  # sources
  GITHUB = 'github'

  # states
  OPEN = 'open'
  CLOSED = 'closed'
  MERGED = 'merged'

  has_and_belongs_to_many :github_users
  belongs_to :organization

  validates :source_id, :source_type, :source, :state, :organization_id,
            :url, :title, :source_created_at, presence: true
end
