import React from "react";
import ReactDOM from "react-dom";
import { BrowserRouter as Router, Route, Link } from "react-router-dom";

import Application from "../containers/Application";
import routes from "../routes";
import "../css/application.css";

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(
    <Router>
      <Application>{routes}</Application>
    </Router>,
    document.getElementById("root")
  );
});
