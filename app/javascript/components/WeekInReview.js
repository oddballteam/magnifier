import React from "react";
import { Query } from "react-apollo";
import { WEEK_IN_REVIEW_QUERY } from "../queries/week_in_review_queries";
import { StatisticsGroup } from "../components/StatisticsCollection";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

const WeekInReviewStatistics = ({ date }) => (
  <Query query={WEEK_IN_REVIEW_QUERY} variables={{ date: date }}>
    {({ data, error, loading }) => {
      if (loading) return <p>Loading...</p>;
      if (error) return <p>Error!</p>;
      if (data && data.weekInReview) {
        return (
          <div className="flex-1">
            <h2>Current</h2>
            <StatisticsGroup
              statistics={data.weekInReview.issuesCreated}
              title={`Issues | Created`}
            />
            <StatisticsGroup
              statistics={data.weekInReview.issuesWorked}
              title={`Issues | Worked`}
            />
            <StatisticsGroup
              statistics={data.weekInReview.issuesClosed}
              title={`Issues | Closed`}
            />
            <StatisticsGroup
              statistics={data.weekInReview.pullRequestsCreated}
              title={`Pull Requests | Created`}
            />
            <StatisticsGroup
              statistics={data.weekInReview.pullRequestsWorked}
              title={`Pull Requests | Worked`}
            />
            <StatisticsGroup
              statistics={data.weekInReview.pullRequestsMerged}
              title={`Pull Requests | Merged`}
            />
          </div>
        );
      }

      return <div />;
    }}
  </Query>
);

class WeekInReview extends React.Component {
  state = {
    date: new Date()
  };

  handleChange = e => {
    this.setState({ date: e });
  };

  render() {
    return (
      <div className="flex-auto">
        <h1 className="hello">Week In Review</h1>
        <div className="flex pb-8">
          <h3 className="pr-8">Select a Week</h3>
          <DatePicker
            onChange={this.handleChange}
            maxDate={new Date()}
            selected={this.state.date}
            todayButton={`Today`}
          />
        </div>
        <div className="flex flex-row">
          <WeekInReviewStatistics date={this.state.date.toISOString()} />
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
