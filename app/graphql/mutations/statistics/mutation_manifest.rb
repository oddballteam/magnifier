# frozen_string_literal: true

require_relative 'create_statistic_mutation'
require_relative 'update_statistic_mutation'

module Mutations
  module Statistics
    module MutationManifest
      extend ActiveSupport::Concern

      included do
        field :create_statistic, resolver: Mutations::Statistics::CreateStatisticMutation
        field :update_statistic, resolver: Mutations::Statistics::UpdateStatisticMutation
      end
    end
  end
end
