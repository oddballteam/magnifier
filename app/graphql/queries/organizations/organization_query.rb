# frozen_string_literal: true

module Queries
  module Organizations
    class OrganizationQuery < Queries::BaseQuery
      description "The organization with the passed criteria."

      type Types::OrganizationType, null: false
      argument :id, ID, required: false
      argument :name, String, required: false

      def resolve(id: nil, name: nil)
        if id
          ::Organization.find_by id: id
        else
          ::Organization.find_by name: name
        end
      end
    end
  end
end
