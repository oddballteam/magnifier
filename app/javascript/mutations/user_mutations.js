import gql from "graphql-tag";
const UPDATE_ACCESS_TOKEN = gql`
  mutation UpdateAccessToken($accessToken: String) {
    updateAccessToken(accessToken: $accessToken) {
      errors
    }
  }
`;
const UPDATE_GITHUB_USERNAME = gql`
  mutation UpdateGithubUsername($githubUsername: String) {
    updateGithubUsername(githubUsername: $githubUsername) {
      errors
    }
  }
`;
const UPDATE_GITHUB_ORG = gql`
  mutation UpdateGithubOrg($githubOrg: String) {
    updateGithubOrg(githubOrg: $githubOrg) {
      errors
    }
  }
`;
export { UPDATE_ACCESS_TOKEN, UPDATE_GITHUB_USERNAME, UPDATE_GITHUB_ORG };
