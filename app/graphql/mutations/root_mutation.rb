# frozen_string_literal: true

module Mutations
  class RootMutation < Types::BaseObject
    include Mutations::Statistics::MutationManifest
  end
end
