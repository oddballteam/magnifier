import gql from "graphql-tag";
const UPDATE_ACCESS_TOKEN = gql`
  mutation UpdateAccessToken($personalAccessToken: String) {
    updateUser(personalAccessToken: $personalAccessToken) {
      errors
    }
  }
`;
const UPDATE_GITHUB_USERNAME = gql`
  mutation UpdateGithubUsername($githubUsername: String) {
    updateUser(githubUsername: $githubUsername) {
      errors
    }
  }
`;
const UPDATE_GITHUB_ORG = gql`
  mutation UpdateGithubOrg($organizationId: Int) {
    updateUser(organizationId: $organizationId) {
      errors
    }
  }
`;
export { UPDATE_ACCESS_TOKEN, UPDATE_GITHUB_USERNAME, UPDATE_GITHUB_ORG };
