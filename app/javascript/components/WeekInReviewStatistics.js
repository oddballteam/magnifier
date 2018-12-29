import React from "react";
import { Query } from "react-apollo";
import { StatisticsGroup } from "./StatisticsCollection";
import { WEEK_IN_REVIEW_QUERY } from "../queries/week_in_review_queries";
import { DateToWeek } from "./DateOptions";

const WeekInReviewStatistics = ({ date }) => (
  <Query
    query={WEEK_IN_REVIEW_QUERY}
    variables={{
      date: date
    }}
  >
    {({ data, error, loading }) => {
      if (loading) {
        return (
          <div className="text-grey-darkest p-3 ml-0 w-1/2"> Loading... </div>
        );
      }
      if (error) {
        return <div className="text-grey-darkest p-3 ml-0 w-1/2"> Error! </div>;
      }
      if (data && data.weekInReview) {
        return (
          <div className="flex-1 pb-8">
            <div className="flex">
              <h3 className="pr-8"> Week in Review for: </h3>
              <div> {DateToWeek(date)} </div>
            </div>
            <StatisticsGroup
              statistics={data.weekInReview.issuesCreated}
              title={`Issues | Created`}
              showRemove={true}
              weekInReviewId={data.weekInReview.id}
            />
            <StatisticsGroup
              statistics={data.weekInReview.issuesWorked}
              title={`Issues | Worked`}
              showRemove={true}
              weekInReviewId={data.weekInReview.id}
            />
            <StatisticsGroup
              statistics={data.weekInReview.issuesClosed}
              title={`Issues | Closed`}
              showRemove={true}
              weekInReviewId={data.weekInReview.id}
            />
            <StatisticsGroup
              statistics={data.weekInReview.pullRequestsCreated}
              title={`Pull Requests | Created`}
              showRemove={true}
              weekInReviewId={data.weekInReview.id}
            />
            <StatisticsGroup
              statistics={data.weekInReview.pullRequestsWorked}
              title={`Pull Requests | Worked`}
              showRemove={true}
              weekInReviewId={data.weekInReview.id}
            />
            <StatisticsGroup
              statistics={data.weekInReview.pullRequestsMerged}
              title={`Pull Requests | Merged`}
              showRemove={true}
              weekInReviewId={data.weekInReview.id}
            />
          </div>
        );
      }

      return <div />;
    }}
  </Query>
);

export { WeekInReviewStatistics };
