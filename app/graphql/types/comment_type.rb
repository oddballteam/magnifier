# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    field :id, Int, null: false
    field :week_in_review_id, Int, null: false
    field :body, String, null: false
    field :type, String, null: false
    field :user_id, Int, null: false
    field :created_at, String, null: false
    field :updated_at, String, null: false
  end
end
