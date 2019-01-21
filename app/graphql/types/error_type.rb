# frozen_string_literal: true

module Types
  class ErrorType < Types::BaseObject
    field :type, String, null: true
    field :message, [String], null: true
  end
end
