# frozen_string_literal: true

module Queries
  module GithubUsers
    # Query class that fetches one GithubUser based on passed criteria
    #
    class GithubUserQuery < Queries::BaseQuery
      description 'The Github User with the passed criteria.'

      type Types::GithubUserType, null: false
      argument :id, ID, required: false
      argument :github_login, String, required: false

      def resolve(id: nil, github_login: nil)
        if id
          ::GithubUser.find_by id: id
        else
          ::GithubUser.find_by github_login: github_login
        end
      end
    end
  end
end
