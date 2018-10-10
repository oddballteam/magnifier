module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String, null: false
    field :last_name, String, null: false
    field :email, String, null: false
    field :encrypted_personal_access_token, String, null: false
    field :encrypted_personal_access_token_iv, String, null: false
    field :git_hub_username, String, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
    field :provider, String, null: true
    field :uid, String, null: true
    field :name, String, null: true
    field :oauth_token, String, null: true
    field :oauth_expires_at, String, null: true
    field :issues, [Types::GitHubIssueType], null: true
  end
end
