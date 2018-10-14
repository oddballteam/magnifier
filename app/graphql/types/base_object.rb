# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    def created_at
      object.created_at&.utc&.iso8601
    end

    def updated_at
      object.created_at&.utc&.iso8601
    end
  end
end
