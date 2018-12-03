import React from 'react';
import { Query } from 'react-apollo';
import styled from 'styled-components';

import StatisticsCollection from './StatisticsCollection';

import { GITHUB_USERS_QUERY } from '../queries/github_user_queries';
import {
  PR_CREATED_QUERY,
  PR_WORKED_QUERY,
  PR_MERGED_QUERY,
  ISSUE_CREATED_QUERY,
  ISSUE_WORKED_QUERY,
  ISSUE_CLOSED_QUERY
} from '../queries/statistic_queries';

// see https://github.com/moment/moment/issues/2608#issuecomment-409240140
import moment from 'moment';
window.moment = moment;

const FormStyled = styled.form`
  display: flex;
  margin-top: 1rem;
`;

const SelectStyled = styled.select`
  border: 1px solid #DAE1E7;
  margin-right: .75rem;
  flex: 2;
`;

const SelectButtonStyled = styled.button`
  border: 1px solid #DAE1E7;
  border-radius: 4px;
  flex: 1;
`;

const GithubUsers = () => (
  <Query query={GITHUB_USERS_QUERY}>
    {({ loading, error, data }) => {
      if (loading) return <option>Loading...</option>;
      if (error) return <option>Error!</option>;

      return data.githubUsers.map((githubUser) => {
        return(
          <option value={githubUser.githubId} key={githubUser.githubId}>
            {`${githubUser.user.firstName} ${githubUser.user.lastName}`}
          </option>
        )
      });
    }}
  </Query>
);

const WEEK = 'week'

/*
@see http://momentjs.com/docs/#/manipulating/start-of/
@example format '2018-11-25T07:00:00.000Z'
*/
const DateOptions = () => {
  const options = ['day', WEEK, 'month', 'quarter', 'year'];

  return options.map((dateSince) => (
    <option
      key={dateSince}
      value={moment().startOf(dateSince).toISOString()}
    >
      {`Start of ${dateSince}`}
    </option>
  ))
};

class Statistics extends React.Component {
  state = {
    githubUserId: undefined,
    date: moment().startOf(WEEK).toISOString()
  }

  handleSubmit = (event) => {
    event.preventDefault();
    this.setState({ githubUserId: event.target.elements[0].value })
  }

  handleChange = (event) => {
    const { name, type, value } = event.target;
    const val = type === 'number' ? parseFloat(value) : value;
    this.setState({ [name]: val });
  };

  render() {
    return (
      <div className="flex-auto">
        <h1 className="hello">Statistics</h1>
        <p>Since: {moment(this.state.date).format("M/D/YY")}</p>

        <FormStyled onSubmit={this.handleSubmit}>
          <SelectStyled
            name="githubUserId"
            onChange={this.handleChange}
            value={this.state.githubUserId}
          >
            <option value=""></option>
            <GithubUsers />
          </SelectStyled>
          <SelectStyled
            name="date"
            onChange={this.handleChange}
            value={this.state.date}
          >
            <DateOptions/>
          </SelectStyled>

          <SelectButtonStyled type="submit">Submit</SelectButtonStyled>
        </FormStyled>

        <StatisticsCollection
          customQuery={ISSUE_CREATED_QUERY}
          date={this.state.date}
          githubUserId={this.state.githubUserId}
          title={`Issues | Created`}
        />
        <StatisticsCollection
          customQuery={ISSUE_WORKED_QUERY}
          date={this.state.date}
          githubUserId={this.state.githubUserId}
          title={`Issues | Worked`}
        />
        <StatisticsCollection
          customQuery={ISSUE_CLOSED_QUERY}
          date={this.state.date}
          githubUserId={this.state.githubUserId}
          title={`Issues | Closed`}
        />
        <StatisticsCollection
          customQuery={PR_CREATED_QUERY}
          date={this.state.date}
          githubUserId={this.state.githubUserId}
          title={`Pull Requests | Created`}
        />
        <StatisticsCollection
          customQuery={PR_WORKED_QUERY}
          date={this.state.date}
          githubUserId={this.state.githubUserId}
          title={`Pull Requests | Worked`}
        />
        <StatisticsCollection
          customQuery={PR_MERGED_QUERY}
          date={this.state.date}
          githubUserId={this.state.githubUserId}
          title={`Pull Requests | Merged`}
        />
      </div>
    );
  }
}

export default Statistics;
