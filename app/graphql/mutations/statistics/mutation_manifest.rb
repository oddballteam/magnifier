# frozen_string_literal: true

module Mutations
  module Statistics
    # Module that:
    #   - lists all of the Statistic mutations
    #   - assigns a field name to each mutation
    #   - maps a given field name to a resolver
    #
    module MutationManifest
      extend ActiveSupport::Concern

      included do
        field :create_statistic, resolver: Mutations::Statistics::CreateStatisticMutation
        field :update_statistic, resolver: Mutations::Statistics::UpdateStatisticMutation
      end
    end
  end
end
