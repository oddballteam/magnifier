# frozen_string_literal: true

module Types
  class OrganizationType < Types::BaseObject
    field :id, Int, null: false
    field :name, String, null: false
    field :url, String, null: false

    field :repositories, [RepositoryType], null: true,
      description: "This organization's repositories, or null if this organization has no repositories."
  end
end
