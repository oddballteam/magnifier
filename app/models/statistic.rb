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
  has_many :accomplishments, dependent: :destroy
  has_many :week_in_reviews, through: :accomplishments
  belongs_to :organization
  belongs_to :repository

  validates :source_id, :source_type, :source, :state, :organization_id,
            :url, :title, :source_created_at, :source_updated_at,
            :repository_id, presence: true

  scope :created_by, ->(github_user_id) { where(source_created_by: github_user_id) }
  scope :of_state, ->(states) { where(state: states) }
  scope :of_type, ->(types) { where(source_type: types) }

  # @param datetime [String] Datetime in iso8601 format.
  # For example, "2018-10-07T20:31:41Z"
  #
  scope :created_after,  ->(datetime) { where('source_created_at >= ?', datetime) }
  scope :updated_after,  ->(datetime) { where('source_updated_at >= ?', datetime) }
  scope :closed_after,   ->(datetime) { where('source_closed_at >= ?', datetime) }
  scope :created_before, ->(datetime) { where('source_created_at <= ?', datetime) }
  scope :updated_before, ->(datetime) { where('source_updated_at <= ?', datetime) }
  scope :closed_before,  ->(datetime) { where('source_closed_at <= ?', datetime) }

  def self.load_repo_and_org
    eager_load(:organization, :repository)
  end

  # The Statistic#assignees db column is an array column.  This query returns
  # all of the statistics that have the passed github_user_id in its assignees array.
  #
  # @param github_user_id [Integer] The GithubUser#github_id the Statistic is assigned to
  # @see https://edgeguides.rubyonrails.org/active_record_postgresql.html#array
  # @see https://www.postgresql.org/docs/current/arrays.html for supported Postgres versions
  #
  def self.assigned_to(github_user_id)
    where('? = ANY (assignees)', github_user_id)
  end
end
