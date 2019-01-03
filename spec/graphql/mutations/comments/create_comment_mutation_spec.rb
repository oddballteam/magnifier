# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Comments::CreateCommentMutation do
  let(:user) { create :user }
  let(:week_in_review) { create :week_in_review, user: user }
  let(:body) { "Week went fine.\n\nDid this that and the other thing." }
  let(:type) { :week_go }
  let(:mutation) do
    <<-GRAPHQL
      mutation {
        createComment(
          attributes: {
            weekInReviewId: #{week_in_review.id},
            body: "#{body}",
            type: "#{type}"
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

  it 'creates a Comment record' do
    expect do
      MagnifierSchema.execute(mutation, context: { current_user: user })
    end.to change { Comment.count }.from(0).to(1)
  end

  it 'creates a Comment record with the passed attributes', :aggregate_failures do
    MagnifierSchema.execute(mutation, context: { current_user: user })

    comment = Comment.first

    expect(comment.body).to eq body
    expect(comment.type).to eq type.to_s
    expect(comment.week_in_review_id).to eq week_in_review.id
    expect(comment.user_id).to eq user.id
  end

  it 'does not return any errors' do
    response = MagnifierSchema.execute(mutation, context: { current_user: user })

    expect(response.dig('errors')).to_not be_present
  end

  context 'when a required attribute is missing' do
    let(:invalid_mutation) do
      <<-GRAPHQL
        mutation {
          createComment(
            attributes: {
              body: "#{body}",
              type: "#{type}"
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

    it 'returns errors' do
      response = MagnifierSchema.execute(invalid_mutation, context: { current_user: user })

      expect(response.dig('errors')).to be_present
    end
  end
end
