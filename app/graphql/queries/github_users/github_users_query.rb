# frozen_string_literal: true

module Queries
  module GithubUsers
    # Query class that fetches all GithubUsers in the db
    #
    class GithubUsersQuery < Queries::BaseQuery
      description 'All Github Users.'

      type [Types::GithubUserType], null: false
      argument :limit, Integer, required: false
      argument :has_user, Boolean, required: false

      def resolve(limit: nil, has_user: true)
        github_users = ::GithubUser.order(id: :asc).limit(limit)
        github_users = github_users.where.not(user_id: nil) if has_user
        github_users
      end
    end
  end
end
