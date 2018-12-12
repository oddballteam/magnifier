import React from "react";
import { Query } from "react-apollo";
import { WEEK_IN_REVIEW_QUERY } from "../queries/week_in_review_queries";
import { StatisticsGroup } from "../components/StatisticsCollection";

const WeekInReviewStatistics = () => (
    {({ data, error, loading }) => {
      if (loading) return <p>Loading...</p>;
      if (error) return <p>Error!</p>;
      if (data && data.weekInReview) {
        return (
          <div className="flex-1">
            <h2>Current</h2>
            {StatisticsGroup(
              data.weekInReview.issuesCreated,
              data.weekInReview.issuesCreated,
              `Issues | Created`
            )}
            {StatisticsGroup(
              data.weekInReview.issuesWorked,
              data.weekInReview.issuesWorked,
              `Issues | Worked`
            )}
            {StatisticsGroup(
              data.weekInReview.issuesClosed,
              data.weekInReview.issuesClosed,
              `Issues | Closed`
            )}
            {StatisticsGroup(
              data.weekInReview.pullRequestsCreated,
              data.weekInReview.pullRequestsCreated,
              `Pull Requests | Created`
            )}
            {StatisticsGroup(
              data.weekInReview.pullRequestsWorked,
              data.weekInReview.pullRequestsWorked,
              `Pull Requests | Worked`
            )}
            {StatisticsGroup(
              data.weekInReview.pullRequestsMerged,
              data.weekInReview.pullRequestsMerged,
              `Pull Requests | Merged`
            )}
          </div>
        );
      }

      return <div>Nada</div>;
    }}
  </Query>
);

class WeekInReview extends React.Component {
  render() {
    return (
      <div className="flex-auto">
        <h1 className="hello">Week In Review</h1>
        <div className="flex flex-row">
          <WeekInReviewStatistics />
          <div className="flex-1">
            <h2>Available</h2>
            <p>Available stats that are not in week in review will go here</p>
          </div>
        </div>
      </div>
    );
  }
}

export default WeekInReview;
