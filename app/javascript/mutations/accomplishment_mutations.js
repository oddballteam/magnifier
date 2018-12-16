import gql from "graphql-tag";

const DELETE_ACCOMPLISHMENT_MUTATION = gql`
  mutation deleteAccomplishment($statisticId: Int!, $weekInReviewId: Int!) {
    deleteAccomplishment(
      statisticId: $statisticId
      weekInReviewId: $weekInReviewId
    ) {
      deleted
      errors
    }
  }
`;

export { DELETE_ACCOMPLISHMENT_MUTATION };
