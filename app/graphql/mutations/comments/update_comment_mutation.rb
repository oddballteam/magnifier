# frozen_string_literal: true

module Mutations
  module Comments
    class UpdateCommentMutation < Mutations::BaseMutation
      description 'Updates a Comment with the passed data.'
      null true

      argument :attributes, Types::CommentInput, required: true
      argument :id, Integer, required: true

      field :comment,
            Types::CommentType,
            null: true,
            description: 'The comment just added'
      field :errors, [String], null: true

      def resolve(attributes:, id:)
        comment = ::Comment.find_by id: id

        if comment.present?
          comment.update! args_for(attributes)
          comment_response comment.reload
        else
          comment_response nil, ["Comment with id #{id} does not exist"]
        end
      rescue ActiveRecord::RecordInvalid => e
        comment_response nil, e.record.errors.full_messages
      end

      private

      def args_for(attributes)
        attributes.to_h.symbolize_keys
      end

      def comment_response(comment, error_messages = [])
        {
          comment: comment,
          errors: error_messages
        }
      end
    end
  end
end
