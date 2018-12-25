import React from "react";
import Swal from "sweetalert2";
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
    if (this.state.deleted) return <span />;
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
                  onClick={() => {
                    Swal({
                      type: "warning",
                      title: "Remove",
                      html: `Remove <span class="italic">"${
                        this.props.title
                      }"</span>?`,
                      showCancelButton: true
                    }).then(saidOk => {
                      if (saidOk.value) {
                        deleteAccomplishment();
                        this.hideStat();
                        Swal({
                          type: "success",
                          title: "Removed!",
                          html: `Removed <span class="italic">"${
                            this.props.title
                          }"</span>`
                        });
                      }
                    });
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
