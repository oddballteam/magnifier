# frozen_string_literal: true

module Types
  module QueryTypes
    module Repository
      # Solution for this include comes from:
      # https://github.com/rmosolgo/graphql-ruby/issues/1828#issuecomment-417897621
      #
      include GraphQL::Schema::Member::GraphQLTypeNames

      def self.included(child_class)
        child_class.field :repository, RepositoryType, null: true do
          description 'Repository for the passed ID'
          argument :id, ID, required: true
        end
      end

      def repository(id)
        ::Repository.find_by(id: id.dig(:id))
      end
    end
  end
end
