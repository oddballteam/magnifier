module Mutations
  module Users
    class UpdateUserDetailsMutation < Mutations::BaseMutation
      description 'Updates a User with the access_token'
      null true
      argument :personalAccessToken, String, required: false
      argument :githubUsername, String, required: false
      argument :organizationId, Int, required: false
      field :user, Types::UserType, null: true
      field :errors, [String], null: true
      def resolve(data)
        current_user = context[:current_user]
        return user_detail_response(nil, ['No Logged In User']) if current_user.nil?
        current_user.update!(data.slice(:personal_access_token, :github_username, :organization_id))
        user_detail_response(current_user)
        rescue ActiveRecord::RecordInvalid => e
          return user_detail_response(nil, e.record.errors.full_messages)
      end

      def user_detail_response(user = nil, errors = [])
        { user: user, errors: errors }
      end
    end
  end
end
