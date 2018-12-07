# frozen_string_literal: true

module Types
  # Defines the fields on GithubUser. Fields expose the data that may
  # be queried, and validated.
  #
  class GithubUserType < Types::BaseObject
    field :id, Int, null: false
    field :user_id, Int, null: true
    field :github_login, String, null: false
    field :avatar_url, String, null: true
    field :api_url, String, null: true
    field :html_url, String, null: true
    field :github_id, Int, null: false
    field :oddball_employee, Boolean, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false

    field(
      :statistics,
      [StatisticType],
      null: true,
      description: "This GithubUser's statistics, or null if this GithubUser has no statistics."
    )

    field :user, UserType, null: true

    def user
      User.find_by(id: object.user_id)
    end
  end
end
