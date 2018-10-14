# frozen_string_literal: true

require_relative 'all_github_users_query'
require_relative 'github_user_query'

module Queries
  module GithubUsers
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :all_github_users, resolver: Queries::GithubUsers::AllGithubUsersQuery
        field :github_user, resolver: Queries::GithubUsers::GithubUserQuery
      end
    end
  end
end
