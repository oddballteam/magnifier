module Mutations
  module Users
    module MutationManifest
      extend ActiveSupport::Concern
      included do
        field :update_user, resolver: Mutations::Users::UpdateUserDetailsMutation
      end
    end
  end
end
