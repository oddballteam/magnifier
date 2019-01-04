import gql from "graphql-tag";
const LOAD_USER_PROFILE = gql`
  {
    me {
      id
      accessToken
      firstName
      lastName
      githubUsername
      org {
        name
      }
      githubUser {
        apiUrl
        avatarUrl
        githubId
        htmlUrl
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
