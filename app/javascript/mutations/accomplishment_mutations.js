import gql from "graphql-tag";

const DELETE_ACCOMPLISHMENT_MUTATION = gql`
  mutation DeleteAccomplishmentMutation(
    $statisticId: Int!
    $weekInReviewId: Int!
  ) {
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
