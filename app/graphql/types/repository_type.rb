# frozen_string_literal: true

module Types
  class RepositoryType < Types::BaseObject
    field :id, Int, null: false
    field :name, String, null: false
    field :url, String, null: false
    field :organization, OrganizationType, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end
