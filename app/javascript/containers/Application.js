import React, { Component } from "react";
import Hello from "../components/Hello";
import Article from "../components/Article";

export default class ApplicationContainer extends Component {
  render() {
    return (
      <div className="container mx-auto">
        <Hello name="world" />
        <Article />
      </div>
    );
  }
}
