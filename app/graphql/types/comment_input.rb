# frozen_string_literal: true

module Types
  # Input Object for mutating a Comment.
  #
  # @see http://graphql-ruby.org/type_definitions/input_objects.html
  #
  class CommentInput < BaseInputObject
    description 'Attributes for creating or updating a Comment.'

    argument :week_in_review_id, Int, required: true
    argument :body, String, required: true
    argument :type, String, required: true
    argument :user_id, Int, required: false
  end
end
