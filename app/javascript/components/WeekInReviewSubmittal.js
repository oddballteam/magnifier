import React from "react";
import { Query } from "react-apollo";
import Textarea from "react-textarea-autosize";
import Swal from "sweetalert2"; // https://sweetalert2.github.io/

import { WEEK_IN_REVIEW_QUERY } from "../queries/week_in_review_queries";
import { StatisticsGroup } from "../components/StatisticsCollection";
import { DateToWeek } from "./DateOptions";
import { buttonClasses } from "../css/sharedTailwindClasses";

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
          <div className="text-grey-darkest p-3 ml-0 w-1/2">Loading...</div>
        );
      }
      if (error) {
        return <div className="text-grey-darkest p-3 ml-0 w-1/2">Error!</div>;
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


const labelClasses =
  "block uppercase tracking-wide text-grey-darker text-xs font-bold mb-2";
const inputClasses =
  "appearance-none block bg-grey-lighter text-grey-darker border border-grey-light rounded py-3 px-4 mb-3 leading-tight focus:outline-none focus:bg-white";
const textAreaClasses = `h-48 w-full ${inputClasses}`;
import { getDateFromUrl } from "./DateOptions";

class WeekInReviewSubmittal extends React.Component {
  state = {
    date: getDateFromUrl(this.props.location.search)
  };

  handleAddIssuePrSubmit = e => {
    e.preventDefault();
  };

  handleCommentsSubmit = e => {
    e.preventDefault();
  };

  handleWeekInReviewSubmit = e => {
    e.preventDefault();
    Swal({
      type: "warning",
      title: "Submit Week in Review?",
      showCancelButton: true
    }).then(saidOk => {
      if (saidOk.value) {
        Swal("Submitted!", "Your Week in Review has been submitted", "success");
      }
    });
  };

  render() {
    return (
      <div className="flex-auto">
        <h1 className="hello"> Week In Review </h1>
        <div className="flex flex-row flex-wrap">
          <WeekInReviewStatistics date={this.state.date} />
          <div className="flex-1 pb-8">
            <h3 className="pb-8">Add Issue/PR</h3>
            <form className="w-full" onSubmit={this.handleAddIssuePrSubmit}>
              <div className="flex flex-row pb-8">
                <input
                  className={`${inputClasses} flex-grow mr-4`}
                  type="text"
                  value={this.state.value}
                  onChange={this.handleChange}
                  placeholder={`Paste GitHub URL of issue or pull request`}
                />
                <button className={`${buttonClasses} h-12`}> Add </button>
              </div>
            </form>
            <h3 className="pb-8">Comments</h3>
            <div className="flex pb-8">
              <form className="w-full" onSubmit={this.handleCommentsSubmit}>
                <label className={labelClasses}>How did your week go?</label>
                <Textarea
                  className={textAreaClasses}
                  minRows={3}
                  name="week_go"
                  onChange={this.handleChange}
                  value={this.state.value}
                />
                <label className={labelClasses}>Any concerns?</label>
                <Textarea
                  className={textAreaClasses}
                  minRows={3}
                  name="concerns"
                  onChange={this.handleChange}
                  value={this.state.value}
                />
                <label className={labelClasses}>
                  How is your Oddball team?
                </label>
                <Textarea
                  className={textAreaClasses}
                  minRows={3}
                  name="oddball_team"
                  onChange={this.handleChange}
                  value={this.state.value}
                />
                <label className={labelClasses}>
                  How is your Project team?
                </label>
                <Textarea
                  className={textAreaClasses}
                  minRows={3}
                  name="project_team"
                  onChange={this.handleChange}
                  value={this.state.value}
                />
                <button className={`${buttonClasses} float-right`}>
                  Save Comments
                </button>
              </form>
            </div>
            <button
              className={`bg-blue hover:bg-blue-dark text-white font-bold py-2 px-4 rounded w-full`}
              onClick={this.handleWeekInReviewSubmit}
            >
              Submit Week In Review
            </button>
          </div>
        </div>
      </div>
    );
  }
}

export default WeekInReviewSubmittal;
