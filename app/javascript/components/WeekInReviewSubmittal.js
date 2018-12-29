import React from "react";
import { Query } from "react-apollo";
import Swal from "sweetalert2"; // https://sweetalert2.github.io/

import { CommentTexarea } from "./CommentTextarea";
import { getDateFromUrl } from "./DateOptions";
import { WeekInReviewStatistics } from "./WeekInReviewStatistics";
import { WEEK_IN_REVIEW_COMMENTS_QUERY } from "../queries/week_in_review_queries";
import { buttonClasses, inputClasses } from "../css/sharedTailwindClasses";

class WeekInReviewSubmittal extends React.Component {
  state = {
    date: getDateFromUrl(this.props.location.search)
  };

  handleChange = e => {
    const { name, type, value } = e.target;
    const val = type === "number" ? parseFloat(value) : value;

    this.setState({
      [name]: val
    });
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
    const CONCERNS = "concerns";
    const ODDBALL_TEAM = "oddball_team";
    const PROJECT_TEAM = "project_team";
    const WEEK_GO = "week_go";

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

            <Query
              query={WEEK_IN_REVIEW_COMMENTS_QUERY}
              variables={{
                date: this.state.date
              }}
            >
              {({ data, error, loading }) => {
                if (loading)
                  return <div className="flex pb-8"> Loading... </div>;
                if (error) return <div className="flex pb-8">Error!</div>;
                if (data && data.weekInReview) {
                  const { comments, id: weekInReviewId } = data.weekInReview;

                  return (
                    <div className="flex pb-8">
                      <form
                        className="w-full"
                        onSubmit={this.handleCommentsSubmit}
                      >
                        <CommentTexarea
                          date={this.state.date}
                          comments={comments}
                          type={WEEK_GO}
                          labelContent={`How did your week go?`}
                          onChange={this.handleChange}
                          weekInReviewId={weekInReviewId}
                        />
                        <CommentTexarea
                          date={this.state.date}
                          comments={comments}
                          type={CONCERNS}
                          labelContent={`Any concerns?`}
                          onChange={this.handleChange}
                          weekInReviewId={weekInReviewId}
                        />
                        <CommentTexarea
                          date={this.state.date}
                          comments={comments}
                          type={ODDBALL_TEAM}
                          labelContent={`How is your Oddball team?`}
                          onChange={this.handleChange}
                          weekInReviewId={weekInReviewId}
                        />
                        <CommentTexarea
                          date={this.state.date}
                          comments={comments}
                          type={PROJECT_TEAM}
                          labelContent={`How is your Project team?`}
                          onChange={this.handleChange}
                          weekInReviewId={weekInReviewId}
                        />
                      </form>
                    </div>
                  );
                }

                return <div className="flex pb-8" />;
              }}
            </Query>

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
