# frozen_string_literal: true

# Class to hold the data we need in order to compile and
# analyze the contributions that employees are making in their
# recurring work done in pull requests and issues.
#
# Sample data sources for these statistics are GitHub's and
# JIRA's APIs.
#
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

  # ownership_types
  ASSIGNED = 'assigned'
  CREATED = 'created'

  # datetime_types
  CREATED_AFTER = 'created_after'
  UPDATED_AFTER = 'updated_after'
  CLOSED_AFTER  = 'closed_after'

  has_and_belongs_to_many :github_users
  belongs_to :organization
  belongs_to :repository

  validates :source_id, :source_type, :source, :state, :organization_id,
            :url, :title, :source_created_at, :source_updated_at,
            :repository_id, presence: true
end
