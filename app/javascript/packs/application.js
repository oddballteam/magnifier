import "../css/application.css";

import React from "react";
import ReactDOM from "react-dom";
import Application from "../containers/Application";

document.addEventListener("DOMContentLoaded", () => {
  ReactDOM.render(<Application />, document.getElementById("root"));
});
