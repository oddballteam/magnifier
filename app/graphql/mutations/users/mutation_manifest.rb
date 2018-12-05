module Mutations
  module Users
    module MutationManifest
      extend ActiveSupport::Concern
      included do
        field :update_access_token, resolver: Mutations::Users::UpdateAccessTokenMutation
        field :update_github_username, resolver: Mutations::Users::UpdateGithubUsernameMutation
        field :update_github_org, resolver: Mutations::Users::UpdateGithubOrgMutation
      end
    end
  end
end
