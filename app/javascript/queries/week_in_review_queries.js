import gql from "graphql-tag";
import { StatisticFragment } from "./statistic_queries"

const WEEK_IN_REVIEW_QUERY = gql`
  query WeekInReviewQuery($date: String!) {
    weekInReview(date: $date) {
      id
      employee {
        firstName
        lastName
      }
      statisticsMostRecentUpdatedAt
      startDate
      endDate
      issuesCreated {
        ...StatisticQueryFields
      }
      issuesWorked {
        ...StatisticQueryFields
      }
      issuesClosed {
        ...StatisticQueryFields
      }
      pullRequestsCreated {
        ...StatisticQueryFields
      }
      pullRequestsWorked {
        ...StatisticQueryFields
      }
      pullRequestsMerged {
        ...StatisticQueryFields
      }
    }
  }
  ${StatisticFragment}
`;

export { WEEK_IN_REVIEW_QUERY };
