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
        current_user.update!(data.slice(:access_token, :github_username, :organization_id))
        rescue ActiveRecord::RecordInvalid => e
          e.record.errors.full_messages
        end
      end
    end
  end
end
