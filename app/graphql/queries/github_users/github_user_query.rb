# frozen_string_literal: true

module Queries
  module GithubUsers
    # Query class that fetches one GithubUser based on passed criteria
    #
    class GithubUserQuery < Queries::BaseQuery
      description 'The Github User with the passed criteria.'

      type Types::GithubUserType, null: false
      argument :id, ID, required: false
      argument :github_id, Integer, required: false
      argument :github_login, String, required: false

      def resolve(id: nil, github_login: nil, github_id: nil)
        if id
          ::GithubUser.find_by id: id
        elsif github_id
          ::GithubUser.find_by github_id: github_id
        elsif github_login
          ::GithubUser.find_by github_login: github_login
        end
      end
    end
  end
end
