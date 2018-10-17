# frozen_string_literal: true

module Queries
  module Repositories
    class AllRepositoriesQuery < Queries::BaseQuery
      description 'All repositories.'

      type [Types::RepositoryType], null: false
      argument :limit, Integer, required: false

      def resolve(limit: nil)
        ::Repository.order(id: :asc).limit(limit)
      end
    end
  end
end
