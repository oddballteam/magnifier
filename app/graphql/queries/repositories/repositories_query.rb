# frozen_string_literal: true

module Queries
  module Repositories
    # Query class that fetches all Repositories in the db
    #
    class RepositoriesQuery < Queries::BaseQuery
      description 'All repositories.'

      type [Types::RepositoryType], null: false
      argument :limit, Integer, required: false

      def resolve(limit: nil)
        ::Repository.order(id: :asc).limit(limit)
      end
    end
  end
end
