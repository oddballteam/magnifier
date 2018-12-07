import gql from "graphql-tag";

const GITHUB_USERS_QUERY = gql`
  query GithubUsersQuery {
    githubUsers {
      githubId
      user {
        firstName
        lastName
      }
    }
  }
`;

export { GITHUB_USERS_QUERY };
