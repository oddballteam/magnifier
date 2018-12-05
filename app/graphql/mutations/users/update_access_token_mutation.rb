module Mutations
  module Users
    class UpdateAccessTokenMutation < Mutations::BaseMutation
      description 'Updates a User with the access_token'
      null true
      argument :accessToken, String, required: false
      field :errors, [String], null: true
      def resolve(access_token:)
        current_user = context[:current_user]
        current_user.personal_access_token = access_token
        current_user.errors unless current_user.save!
      end
    end
  end
end
