# frozen_string_literal: true

module Queries
  module GithubUsers
    # Query class that fetches all GithubUsers in the db
    #
    class GithubUsersQuery < Queries::BaseQuery
      description 'All Github Users.'

      type [Types::GithubUserType], null: false
      argument :limit, Integer, required: false

      def resolve(limit: nil)
        ::GithubUser.order(id: :asc).limit(limit)
      end
    end
  end
end
