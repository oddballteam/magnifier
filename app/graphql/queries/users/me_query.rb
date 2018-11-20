module Queries
  module Users
    class MeQuery < Queries::BaseQuery
      description 'The Logged in user'
      type Types::UserType, null: true
      def resolve
        context[:current_user]
      end
    end
  end
end
