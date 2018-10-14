# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, Int, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :email, String, null: false
    field :github_username, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end
