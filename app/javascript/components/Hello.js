import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import gql from 'graphql-tag';
import { Query } from "react-apollo";

const Login = () => {
  return (
      <span>
      <a href="/auth/google_oauth2">Please login by going here</a>
      </span>
  )
}
const Logout = () => (
  <span>
  <a href="/signout">Signout</a>
  </span>

)

const TEST_QUERY = gql`
 {
   me {
     name
   }
 }
`;

class Hello extends React.Component {
  render() {
    return (
      <Query query={TEST_QUERY} >
      {({ loading, error, data }) => {
        if (loading) return "Loading";
        if (error) return `Error!: ${error}`;
        if(!data.me)  {
          return <Login />
        }
        return (
          <div>
            <h1 className="hello">Hello {data.me.name}!</h1>
            <Logout />
          </div>
        )
      }}
      </Query>
    );
  }
} 
export default Hello;