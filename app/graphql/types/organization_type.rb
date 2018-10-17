# frozen_string_literal: true

module Types
  # Defines the fields on Organization. Fields expose the data that may
  # be queried, and validated.
  #
  class OrganizationType < Types::BaseObject
    field :id, Int, null: false
    field :name, String, null: false
    field :url, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false

    field(
      :repositories,
      [RepositoryType],
      null: true,
      description: "This organization's repositories, or null if this organization has no repositories."
    )
  end
end
