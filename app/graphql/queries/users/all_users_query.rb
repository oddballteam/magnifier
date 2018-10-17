# frozen_string_literal: true

module Queries
  module Users
    class AllUsersQuery < Queries::BaseQuery
      description 'All Users.'

      type [Types::UserType], null: false
      argument :limit, Integer, required: false

      def resolve(limit: nil)
        ::User.order(id: :asc).limit(limit)
      end
    end
  end
end
