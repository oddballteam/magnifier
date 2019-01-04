import React from "react";
import { Route, Switch } from "react-router-dom";

import Goodbye from "./components/Goodbye";
import Hello from "./components/Hello";
import NotFoundPage from "./components/NotFoundPage";
import Profile from "./components/Profile";
import Statistics from "./components/Statistics";
import WeekInReview from "./components/WeekInReview";
import WeekInReviewSubmittal from "./components/WeekInReviewSubmittal";

const routes = (
  <Switch>
    <Route exact path="/" component={Hello} />
    <Route path="/goodbye" component={Goodbye} />
    <Route path="/profile" component={Profile} />
    <Route path="/statistics" component={Statistics} />
    <Route path="/week-in-review" component={WeekInReview} />
    <Route path="/week-in-review-submittal" component={WeekInReviewSubmittal} />
    <Route component={NotFoundPage} />
  </Switch>
);
export default routes;
