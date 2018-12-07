module Mutations
  module Users
    class UpdateUserDetailsMutation < Mutations::BaseMutation
      description 'Updates a User with the access_token'
      null true
      argument :accessToken, String, required: false
      argument :githubUsername, String, required: false
      argument :githubOrg, String, required: false
      field :errors, [String], null: true
      def resolve(data)
        current_user = context[:current_user]
        if data[:github_org]
          current_user.organization_id = Organization.find_or_create_by(name: data[:github_org]).id
        end
        current_user.update(data.slice(:access_token, :github_username))
        current_user.errors unless current_user.save!
      end
    end
  end
end
