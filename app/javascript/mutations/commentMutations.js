import gql from "graphql-tag";

const CREATE_COMMENT_MUTATION = gql`
  mutation CreateCommentMutation($attributes: CommentInput!) {
    createComment(attributes: $attributes) {
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
`;

const UPDATE_COMMENT_MUTATION = gql`
  mutation UpdateCommentMutation($id: Int!, $attributes: CommentInput!) {
    updateComment(id: $id, attributes: $attributes) {
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
`;

export { CREATE_COMMENT_MUTATION, UPDATE_COMMENT_MUTATION };
