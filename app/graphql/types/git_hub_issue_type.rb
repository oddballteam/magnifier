module Types
  class GitHubIssueType < Types::BaseObject
    field :id, ID, null: false
    field :url, String, null: false
    field :repository_url, String, null: false
    field :labels_url, String, null: false
    field :comments_url, String, null: false
    field :comments_url, String, null: false
    field :events_url, String, null: false
    field :html_url, String, null: false
    field :title, String, null: false
    field :user, Types::UserType, null: false
  end
end
