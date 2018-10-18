# frozen_string_literal: true

require_relative 'organizations_query'
require_relative 'organization_query'

module Queries
  module Organizations
    #   - lists all of the Organization queries
    #   - assigns a field name to each query
    #   - maps a given field name to a resolver
    #
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :organization, resolver: Queries::Organizations::OrganizationQuery
        field :organizations, resolver: Queries::Organizations::OrganizationsQuery
      end
    end
  end
end
