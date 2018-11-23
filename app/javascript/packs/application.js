import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Route, Link } from "react-router-dom";
import ApolloClient from "apollo-boost";

import Application from "../containers/Application";
import routes from "../routes";
import "../css/application.css";
import gql from "graphql-tag";
import { ApolloProvider } from "react-apollo";

const client = new ApolloClient({
  uri: "/graphql"
});

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <Router>
      <ApolloProvider client={client}>
        <Application>{routes}</Application>
      </ApolloProvider>
    </Router>,
    document.getElementById("root")
  );
});
