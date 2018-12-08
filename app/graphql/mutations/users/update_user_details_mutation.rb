module Mutations
  module Users
    class UpdateUserDetailsMutation < Mutations::BaseMutation
      description 'Updates a User with the access_token'
      null true
      argument :accessToken, String, required: false
      argument :githubUsername, String, required: false
      argument :organizationId, Int, required: false
      field :errors, [String], null: true
      def resolve(data)
        current_user = context[:current_user]
        current_user.update(data.slice(:access_token, :github_username, :organization_id))
        current_user.errors unless current_user.save!
      end
    end
  end
end
