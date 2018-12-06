import React from "react";

class Statistic extends React.Component {
  render() {
    return (
      <div className='border border-grey-light rounded text-grey-darkest p-3 m-1 ml-0 max-w-sm'>
        <p className="pb-3">
          <a href={this.props.url} target="_blank">
            {this.props.title}
          </a>
        </p>
        <p className="uppercase text-black font-bold text-xs">{this.props.repository.name}</p>
        <p className="capitalize">{`${this.props.state} ${this.props.sourceType}`} </p>
      </div>
    );
  }
}

export default Statistic;
