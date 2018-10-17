# frozen_string_literal: true

module Queries
  module Users
    class UserQuery < Queries::BaseQuery
      description 'The User with the passed criteria.'

      type Types::UserType, null: false
      argument :id, ID, required: false
      argument :github_username, String, required: false

      def resolve(id: nil, github_username: nil)
        if id
          ::User.find_by id: id
        else
          ::User.find_by github_username: github_username
        end
      end
    end
  end
end
