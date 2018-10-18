# frozen_string_literal: true

module Queries
  module Users
    # Query class that fetches all Users in the db
    #
    class UsersQuery < Queries::BaseQuery
      description 'All Users.'

      type [Types::UserType], null: false
      argument :limit, Integer, required: false

      def resolve(limit: nil)
        ::User.order(id: :asc).limit(limit)
      end
    end
  end
end
