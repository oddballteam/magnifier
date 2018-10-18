# frozen_string_literal: true

require_relative 'github_users_query'
require_relative 'github_user_query'

module Queries
  module GithubUsers
    # Module that:
    #   - lists all of the GithubUser queries
    #   - assigns a field name to each query
    #   - maps a given field name to a resolver
    #
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :github_user, resolver: Queries::GithubUsers::GithubUserQuery
        field :github_users, resolver: Queries::GithubUsers::GithubUsersQuery
      end
    end
  end
end
