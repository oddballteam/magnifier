import React, { Component } from "react";
import { Query } from "react-apollo";
import gql from "graphql-tag";

import Hello from "../components/Hello";
import Article from "../components/Article";
import Navbar from "../components/Navbar";

// any application wide elements can be added in this component
export default class ApplicationContainer extends Component {
  render() {
    return (
      <div>
        <Navbar />
        <div className="container mx-auto flex">{this.props.children}</div>
      </div>
    );
  }
}
