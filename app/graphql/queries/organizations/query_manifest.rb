# frozen_string_literal: true

require_relative 'all_organizations_query'
require_relative 'organization_query'

module Queries
  module Organizations
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :all_organizations, resolver: Queries::Organizations::AllOrganizationsQuery
        field :organization, resolver: Queries::Organizations::OrganizationQuery
      end
    end
  end
end
