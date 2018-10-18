import React from "react";
import { Route, Link, Switch } from "react-router-dom";

import Article from "./components/Article";
import Hello from "./components/Hello";
import Goodbye from "./components/Goodbye";
import NotFoundPage from "./components/NotFoundPage";

const routes = (
  <Switch>
    <Route exact path="/" component={Hello} />
    <Route path="/goodbye" component={Goodbye} />
    <Route component={NotFoundPage} />
  </Switch>
);
export default routes;
