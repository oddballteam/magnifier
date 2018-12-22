import React from "react";
import { Mutation } from "react-apollo";
import { DELETE_ACCOMPLISHMENT_MUTATION } from "../mutations/accomplishment_mutations";

class Statistic extends React.Component {
  state = {
    deleted: false
  };

  hideStat = () => {
    this.setState({ deleted: true });
  };

  render() {
    if (this.state.deleted) return <div>Poof gone!</div>;
    return (
      <div className="border border-grey-light rounded text-grey-darkest p-3 m-1 ml-0 max-w-sm">
        {this.props.showRemove ? (
          <Mutation
            mutation={DELETE_ACCOMPLISHMENT_MUTATION}
            variables={{
              statisticId: this.props.id,
              weekInReviewId: this.props.weekInReviewId
            }}
          >
            {(deleteAccomplishment, { error }) => {
              if (error) return <span> Error! </span>;
              return (
                <span
                  className="float-right hover:text-teal-light no-underline cursor-pointer"
                  onClick={e => {
                    if (window.confirm(`Remove "${this.props.title}"?`)) {
                      deleteAccomplishment();
                      this.hideStat();
                    }
                  }}
                  title={`Remove`}
                >
                  x
                </span>
              );
            }}
          </Mutation>
        ) : (
          ""
        )}
        <p className="pb-3">
          <a href={this.props.url} target="_blank">
            {this.props.title}
          </a>
        </p>
        <p className="uppercase text-black font-bold text-xs">
          {this.props.repository.name}
        </p>
        <p className="capitalize">
          {`${this.props.state} ${this.props.sourceType}`}{" "}
        </p>
      </div>
    );
  }
}

export default Statistic;
