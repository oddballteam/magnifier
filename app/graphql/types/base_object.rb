# frozen_string_literal: true

module Types
  # Classes extending GraphQL::Schema::Object describe Object types
  # and customize their behavior.
  #
  # @see http://graphql-ruby.org/type_definitions/objects.html#object-classes
  #
  class BaseObject < GraphQL::Schema::Object
    def created_at
      object.created_at&.utc&.iso8601
    end

    def updated_at
      object.created_at&.utc&.iso8601
    end
  end
end
