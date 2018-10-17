# frozen_string_literal: true

module Queries
  module Repositories
    class RepositoryQuery < Queries::BaseQuery
      description 'The repository with the passed criteria.'

      type Types::RepositoryType, null: false
      argument :id, ID, required: false
      argument :name, String, required: false

      def resolve(id: nil, name: nil)
        if id
          ::Repository.find_by id: id
        else
          ::Repository.find_by name: name
        end
      end
    end
  end
end
