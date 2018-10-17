# frozen_string_literal: true

module Mutations
  # The parent list of potential mutations that are made available to
  # the GraphQL schema, MagnifierSchema.
  #
  # This list is comprised of individual lists (or manifests), each
  # one containing their own assembly of available mutations.
  #
  class RootMutation < Types::BaseObject
    include Mutations::Statistics::MutationManifest
  end
end
