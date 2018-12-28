import React from "react";
import { Query } from "react-apollo";
import Textarea from "react-textarea-autosize";
import Swal from "sweetalert2"; // https://sweetalert2.github.io/

import { getDateFromUrl } from "./DateOptions";
import { WeekInReviewStatistics } from "./WeekInReviewStatistics";
import { buttonClasses, inputClasses } from "../css/sharedTailwindClasses";

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
