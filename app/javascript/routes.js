import React from "react";
import { Route, Link, Switch } from "react-router-dom";

import Article from "./components/Article";
import Goodbye from "./components/Goodbye";
import Hello from "./components/Hello";
import NotFoundPage from "./components/NotFoundPage";
import Profile from "./components/Profile";
import Statistics from "./components/Statistics";

const routes = (
  <Switch>
    <Route exact path="/" component={Hello} />
    <Route path="/goodbye" component={Goodbye} />
    <Route path="/profile" component={Profile} />
    <Route path="/statistics" component={Statistics} />
    <Route component={NotFoundPage} />
  </Switch>
);
export default routes;
