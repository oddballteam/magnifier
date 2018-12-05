module Mutations
  module Users
    module MutationManifest
      extend ActiveSupport::Concern
      included do
        field :update_access_token, resolver: Mutations::Users::UpdateAccessTokenMutation
      end
    end
  end
end
