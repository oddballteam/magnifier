import gql from "graphql-tag";

const StatisticFragment = gql`
  fragment StatisticQueryFields on Statistic {
    id
    assignees
    sourceType
    state
    source
    title
    sourceCreatedBy
    sourceCreatedAt
    sourceUpdatedAt
    sourceClosedAt
    url
    repository {
      name
      url
    }
    organization {
      name
      url
    }
  }
`;

const PR_CREATED_QUERY = gql`
  query PR_CREATED_QUERY(
    $githubUserId: Int!
    $date: String!
    $forWeek: Boolean!
  ) {
    statistics(
      type: [PR]
      state: [OPEN, CLOSED, MERGED]
      ownershipType: CREATED
      githubUserId: $githubUserId
      datetimeType: CREATED
      datetime: $date
      forWeek: $forWeek
    ) {
      ...StatisticQueryFields
    }
  }
  ${StatisticFragment}
`;

const PR_WORKED_QUERY = gql`
  query PrWorkedQuery($githubUserId: Int!, $date: String!, $forWeek: Boolean!) {
    statistics(
      type: [PR]
      state: [OPEN, CLOSED, MERGED]
      ownershipType: CREATED
      githubUserId: $githubUserId
      datetimeType: UPDATED
      datetime: $date
      forWeek: $forWeek
    ) {
      ...StatisticQueryFields
    }
  }
  ${StatisticFragment}
`;

const PR_MERGED_QUERY = gql`
  query PrMergedQuery($githubUserId: Int!, $date: String!, $forWeek: Boolean!) {
    statistics(
      type: [PR]
      state: [MERGED]
      ownershipType: CREATED
      githubUserId: $githubUserId
      datetimeType: CLOSED
      datetime: $date
      forWeek: $forWeek
    ) {
      ...StatisticQueryFields
    }
  }
  ${StatisticFragment}
`;

const ISSUE_CREATED_QUERY = gql`
  query IssueCreatedQuery(
    $githubUserId: Int!
    $date: String!
    $forWeek: Boolean!
  ) {
    statistics(
      type: [ISSUE]
      state: [OPEN, CLOSED]
      ownershipType: CREATED
      githubUserId: $githubUserId
      datetimeType: CREATED
      datetime: $date
      forWeek: $forWeek
    ) {
      ...StatisticQueryFields
    }
  }
  ${StatisticFragment}
`;

const ISSUE_WORKED_QUERY = gql`
  query IssueWorkedQuery(
    $githubUserId: Int!
    $date: String!
    $forWeek: Boolean!
  ) {
    statistics(
      type: [ISSUE]
      state: [OPEN, CLOSED]
      ownershipType: ASSIGNED
      githubUserId: $githubUserId
      datetimeType: UPDATED
      datetime: $date
      forWeek: $forWeek
    ) {
      ...StatisticQueryFields
    }
  }
  ${StatisticFragment}
`;

const ISSUE_CLOSED_QUERY = gql`
  query IssueClosedQuery(
    $githubUserId: Int!
    $date: String!
    $forWeek: Boolean!
  ) {
    statistics(
      type: [ISSUE]
      state: [CLOSED]
      ownershipType: ASSIGNED
      githubUserId: $githubUserId
      datetimeType: CLOSED
      datetime: $date
      forWeek: $forWeek
    ) {
      ...StatisticQueryFields
    }
  }
  ${StatisticFragment}
`;

export {
  PR_CREATED_QUERY,
  PR_WORKED_QUERY,
  PR_MERGED_QUERY,
  ISSUE_CREATED_QUERY,
  ISSUE_WORKED_QUERY,
  ISSUE_CLOSED_QUERY,
  StatisticFragment
};
