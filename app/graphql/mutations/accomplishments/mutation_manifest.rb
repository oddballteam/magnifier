# frozen_string_literal: true

module Mutations
  module Accomplishments
    # Module that:
    #   - lists all of the Accomplishment mutations
    #   - assigns a field name to each mutation
    #   - maps a given field name to a resolver
    #
    module MutationManifest
      extend ActiveSupport::Concern

      included do
        field :accomplishments_create_for_statistic, resolver: Mutations::Accomplishments::AccomplishmentsCreateForStatisticMutation
        field :delete_accomplishment, resolver: Mutations::Accomplishments::DeleteAccomplishmentMutation
      end
    end
  end
end
