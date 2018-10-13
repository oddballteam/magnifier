# frozen_string_literal: true

module Types
  module QueryTypes
    module Organization
      include GraphQL::Schema::Member::GraphQLTypeNames

      def self.included(child_class)
        # When returning a collection, the type param must be
        # wrapped in an array (e.g. [OrganizationType, null: true])
        #
        child_class.field :all_organizations,
              [OrganizationType, null: true],
              description: 'All GitHub organizations',
              null: false do

          argument :limit,
                   Integer,
                   required: false
        end

        child_class.field :organization, OrganizationType, null: true do
          description 'Organization for the passed ID'
          argument :id, ID, required: true
        end
      end

      def all_organizations(limit=nil)
        amount = limit&.dig(:limit)

        ::Organization.order(id: :asc).limit(amount)
      end

      def organization(id)
        ::Organization.find_by(id: id.dig(:id))
      end
    end
  end
end
