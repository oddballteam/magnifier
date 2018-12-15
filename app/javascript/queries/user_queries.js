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
    organizations {
      id
      name
      url
    }
  }
`;

export { LOAD_USER_PROFILE };
