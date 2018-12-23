import React from "react";
import { Query } from "react-apollo";
import StatisticsCollection from "./StatisticsCollection";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import { DateToWeek } from "./DateOptions";
import { LOAD_USER_PROFILE } from "../queries/user_queries";
import {
  PR_CREATED_QUERY,
  PR_WORKED_QUERY,
  PR_MERGED_QUERY,
  ISSUE_CREATED_QUERY,
  ISSUE_WORKED_QUERY,
  ISSUE_CLOSED_QUERY
} from "../queries/statistic_queries";

const WeekInReviewStatistics = ({ date }) => (
  <Query query={LOAD_USER_PROFILE}>
    {({ data, error, loading }) => {
      if (loading) return <p> Loading... </p>;
      if (error) return <p> Error! </p>;
      const { githubId } = data.me.githubUser;

      return (
        <div>
          <div className="flex pb-8">
            <h3 className="pr-8"> Statistics For: </h3>{" "}
            <div> {DateToWeek(date)} </div>
          </div>
          <div className="flex">
            <h3 className="pr-8">Employee:</h3>
            <div>{`${data.me.firstName} ${data.me.lastName}`}</div>
          </div>
          <StatisticsCollection
            customQuery={ISSUE_CREATED_QUERY}
            date={date}
            forWeek
            githubUserId={githubId}
            title={`Issues | Created`}
          />
          <StatisticsCollection
            customQuery={ISSUE_WORKED_QUERY}
            date={date}
            forWeek
            githubUserId={githubId}
            title={`Issues | Worked`}
          />
          <StatisticsCollection
            customQuery={ISSUE_CLOSED_QUERY}
            date={date}
            forWeek
            githubUserId={githubId}
            title={`Issues | Closed`}
          />
          <StatisticsCollection
            customQuery={PR_CREATED_QUERY}
            date={date}
            forWeek
            githubUserId={githubId}
            title={`Pull Requests | Created`}
          />
          <StatisticsCollection
            customQuery={PR_WORKED_QUERY}
            date={date}
            forWeek
            githubUserId={githubId}
            title={`Pull Requests | Worked`}
          />
          <StatisticsCollection
            customQuery={PR_MERGED_QUERY}
            date={date}
            forWeek
            githubUserId={githubId}
            title={`Pull Requests | Merged`}
          />
        </div>
      );
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
          <h3 className="pr-8">Select a Week:</h3>
          <DatePicker
            onChange={this.handleChange}
            maxDate={new Date()}
            selected={this.state.date}
            todayButton={`Today`}
          />
        </div>
        <div>
          <WeekInReviewStatistics date={this.state.date.toISOString()} />
        </div>
      </div>
    );
  }
}

export default WeekInReview;
