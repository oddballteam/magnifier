import React from "react";
import { Route, Link, Switch } from "react-router-dom";

import Article from "./components/Article";
import Hello from "./components/Hello";
import Goodbye from "./components/Goodbye";
import NotFoundPage from "./components/NotFoundPage";
import Profile from "./components/Profile";

const routes = (
  <Switch>
    <Route exact path="/" component={Hello} />
    <Route path="/goodbye" component={Goodbye} />
    <Route path="/profile" component={Profile} />
    <Route component={NotFoundPage} />
  </Switch>
);
export default routes;
