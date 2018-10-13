# frozen_string_literal: true

module Types
  module QueryTypes
    module GithubUser
      include GraphQL::Schema::Member::GraphQLTypeNames

      def self.included(child_class)
        child_class.field :all_github_users,
              [GithubUserType, null: true],
              description: 'All GitHub users',
              null: false do

          argument :limit,
                   Integer,
                   required: false
        end

        child_class.field :github_user, GithubUserType, null: true do
          description 'GithubUser for the passed ID'
          argument :github_id, ID, required: true
        end
      end

      def all_github_users(limit=nil)
        amount = limit&.dig(:limit)

        ::GithubUser.order(id: :asc).limit(amount)
      end

      def github_user(github_id)
        ::GithubUser.find_by(github_id: github_id.dig(:github_id))
      end
    end
  end
end
