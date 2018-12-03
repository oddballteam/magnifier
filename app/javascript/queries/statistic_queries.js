import gql from "graphql-tag";

const PR_CREATED_QUERY = gql`
  query PR_CREATED_QUERY($githubUserId: Int!, $date: String!) {
    statistics(
      type: [PR],
      state: [OPEN, MERGED],
      ownershipType: CREATED,
      githubUserId: $githubUserId,
      datetimeType: CREATED_AFTER,
      datetime: $date
    ){
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
  }
`;

const PR_WORKED_QUERY = gql`
  query PR_WORKED_QUERY($githubUserId: Int!, $date: String!) {
    statistics(
      type: [PR],
      state: [OPEN, MERGED],
      ownershipType: CREATED,
      githubUserId: $githubUserId,
      datetimeType: UPDATED_AFTER,
      datetime: $date
    ){
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
  }
`;

const PR_MERGED_QUERY = gql`
  query PR_MERGED_QUERY($githubUserId: Int!, $date: String!) {
    statistics(
      type: [PR],
      state: [MERGED],
      ownershipType: CREATED,
      githubUserId: $githubUserId,
      datetimeType: CLOSED_AFTER,
      datetime: $date
    ){
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
  }
`;

const ISSUE_CREATED_QUERY = gql`
  query ISSUE_CREATED_QUERY($githubUserId: Int!, $date: String!) {
    statistics(
      type: [ISSUE],
      state: [OPEN, CLOSED],
      ownershipType: CREATED,
      githubUserId: $githubUserId,
      datetimeType: CREATED_AFTER,
      datetime: $date
    ){
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
  }
`;

const ISSUE_WORKED_QUERY = gql`
  query ISSUE_WORKED_QUERY($githubUserId: Int!, $date: String!) {
    statistics(
      type: [ISSUE],
      state: [OPEN, CLOSED],
      ownershipType: ASSIGNED,
      githubUserId: $githubUserId,
      datetimeType: UPDATED_AFTER,
      datetime: $date
    ){
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
  }
`;

const ISSUE_CLOSED_QUERY = gql`
  query ISSUE_CLOSED_QUERY($githubUserId: Int!, $date: String!) {
    statistics(
      type: [ISSUE],
      state: [CLOSED],
      ownershipType: ASSIGNED,
      githubUserId: $githubUserId,
      datetimeType: CLOSED_AFTER,
      datetime: $date
    ){
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
  }
`;

export { PR_CREATED_QUERY, PR_WORKED_QUERY, PR_MERGED_QUERY, ISSUE_CREATED_QUERY, ISSUE_WORKED_QUERY, ISSUE_CLOSED_QUERY };
