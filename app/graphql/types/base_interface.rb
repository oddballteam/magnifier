# frozen_string_literal: true

module Types
  # Interfaces are lists of fields which may be implemented by object types. They
  # include GraphQL::Schema::Interface.
  #
  # @see http://graphql-ruby.org/type_definitions/interfaces.html#defining-interface-types
  #
  module BaseInterface
    include GraphQL::Schema::Interface
  end
end
