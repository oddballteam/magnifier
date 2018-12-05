module Mutations
  module Users
    class UpdateGithubOrgMutation < Mutations::BaseMutation
      description "Update a user's github org"
      null true
      argument :githubOrg, String, required: false
      field :errors, [String], null: true
      def resolve(github_org:)
        current_user = context[:current_user]
        current_user.organization_id = Organization.find_or_create_by(name: github_org).id
        current_user.errors unless current_user.save!
      end
    end
  end
end
