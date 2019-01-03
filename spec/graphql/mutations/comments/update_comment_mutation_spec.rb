# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Comments::UpdateCommentMutation do
  let(:user) { create :user }
  let(:week_in_review) { create :week_in_review, user: user }
  let!(:comment) { create :comment, user: user, week_in_review: week_in_review }
  let(:original_body) { comment.body }
  let(:new_body) { 'Some new body' }
  let(:mutation) do
    <<-GRAPHQL
      mutation {
        updateComment(
          id: #{comment.id},
          attributes: {
            weekInReviewId: #{comment.week_in_review_id},
            body: "#{new_body}",
            type: "#{comment.type}"
          }
        ) {
          comment {
            id
            weekInReviewId
            body
            type
            userId
          }
          errors
        }
      }
    GRAPHQL
  end

  it 'does not create a new Comment record' do
    expect do
      MagnifierSchema.execute(mutation, context: { current_user: user })
    end.to change { Comment.count }.by(0)
  end

  it 'updates a Comment record with the passed attributes', :aggregate_failures do
    expect(comment.body).to eq original_body

    MagnifierSchema.execute(mutation, context: { current_user: user })

    expect(comment.reload.body).to eq new_body
  end

  it 'does not return any errors', :aggregate_failures do
    response = MagnifierSchema.execute(mutation, context: { current_user: user })

    expect(response.dig('errors')).to_not be_present
  end

  context 'when missing required attributes' do
    let(:invalid_mutation) do
      <<-GRAPHQL
        mutation {
          updateComment(
            id: #{comment.id},
            attributes: {
              body: "#{new_body}",
              type: "#{comment.type}"
            }
          ) {
            comment {
              id
            }
            errors
          }
        }
      GRAPHQL
    end

    it 'returns an error', :aggregate_failures do
      response = MagnifierSchema.execute(invalid_mutation, context: { current_user: user })

      expect(response.dig('errors')).to be_present
    end
  end
end
