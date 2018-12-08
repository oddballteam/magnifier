import React, { Component } from "react";
import { BrowserRouter } from "react-router-dom";

import Hello from "../components/Hello";
import Article from "../components/Article";
import Navbar from "../components/Navbar";

// any application wide elements can be added in this component
export default class ApplicationContainer extends Component {
  componentDidMount() {
    const query = `
    {
      me{
        id
      }
    }
    `;
    fetch("/graphql", {
      method: "post",
      body: JSON.stringify({
        query,
        operationName: null,
        variables: null
      }),
      mode: "cors",
      headers: {
        "Content-Type": "application/json"
      },
      credentials: "same-origin"
    })
      .then(resp => {
        return resp.json();
      })
      .then(data => {
        console.log(data);
      });
  }
  render() {
    return (
      <div>
        <Navbar />
        <div className="container mx-auto flex">{this.props.children}</div>
      </div>
    );
  }
}
