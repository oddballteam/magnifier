import gql from "graphql-tag";
const LOAD_USER_PROFILE = gql`
  {
    me {
      id
      hasAccessToken
      githubUsername
      org {
        name
      }
    }
  }
`;

export { LOAD_USER_PROFILE };
