import React, { Component } from "react";
import { Query, Mutation } from "react-apollo";
import gql from "graphql-tag";

const UPDATE_ACCESS_TOKEN = gql`
  mutation UpdateAccessToken($accessToken: String!) {
    updateAccessToken(accessToken: $accessToken) {
      errors
    }
  }
`;

const UpdateAccessToken = () => {
  let input;
  return (
    <Mutation mutation={UPDATE_ACCESS_TOKEN}>
      {(updateAccessToken, { data, error }) => {
        if (error) {
          return <div>{JSON.stringify(error)}</div>;
        }
        return (
          <div>
            <form
              onSubmit={e => {
                e.preventDefault();
                updateAccessToken({ variables: { accessToken: "hardcoded" } });
                input.value = "";
              }}
            >
              <input
                ref={node => {
                  input = node;
                }}
                type="text"
              />
              <button type="submit">Update Token</button>
            </form>
          </div>
        );
      }}
    </Mutation>
  );
};

export default class Profile extends Component {
  render() {
    return (
      <Query
        query={gql`
          {
            me {
              id
              hasAccessToken
            }
          }
        `}
      >
        {({ loading, error, data }) => {
          if (loading) return <p>Loading...</p>;
          if (error) return <p>Error</p>;

          return (
            <div>
              {!data.hasAccessToken && <UpdateAccessToken />}

              {JSON.stringify(data.me)}
            </div>
          );
        }}
      </Query>
    );
  }
}
