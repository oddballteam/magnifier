import React from "react";
import { Route, Link, Switch } from "react-router-dom";

import Article from "./components/Article";
import Goodbye from "./components/Goodbye";
import Hello from "./components/Hello";
import NotFoundPage from "./components/NotFoundPage";
import Statistics from "./components/Statistics";
import WeekInReview from "./components/WeekInReview";

const routes = (
  <Switch>
    <Route exact path="/" component={Hello} />
    <Route path="/goodbye" component={Goodbye} />
    <Route path="/statistics" component={Statistics} />
    <Route path="/week-in-review" component={WeekInReview} />
    <Route component={NotFoundPage} />
  </Switch>
);
export default routes;
