# frozen_string_literal: true

module Mutations
  module Comments
    class CreateCommentMutation < Mutations::BaseMutation
      description 'Updates a Comment with the passed data.'
      null true

      argument :attributes, Types::CommentInput, required: true

      field :comment,
            Types::CommentType,
            null: true,
            description: 'The comment just added'
      field :errors, [String], null: true

      def resolve(attributes:)
        current_user = context[:current_user]
        user_hash    = { user_id: current_user.id }

        raise ::WeekInReviews::Error, 'Requires a logged in user' if current_user.blank?

        args    = attributes.to_h.merge(user_hash).symbolize_keys
        comment = ::Comment.create! args

        comment_response comment
      rescue ActiveRecord::RecordInvalid => e
        comment_response(nil, e.record.errors.full_messages)
      end

      private

      def comment_response(comment, error_messages = [])
        {
          comment: comment,
          errors: error_messages
        }
      end
    end
  end
end
