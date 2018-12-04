import React from 'react';
import { Query } from 'react-apollo';
import styled from 'styled-components';

import { startOfWeek, DateOptions, datetimeToDate } from './DateOptions';
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

const FormStyled = styled.form`
  display: flex;
  margin-top: 1rem;
`;

const SelectStyled = styled.select`
  border: 1px solid #DAE1E7;
  margin-right: .75rem;
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

class Statistics extends React.Component {
  state = {
    githubUserId: undefined,
    date: startOfWeek
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
        <p>Since: {datetimeToDate(this.state.date)}</p>

        <FormStyled>
          <SelectStyled
            name="date"
            onChange={this.handleChange}
            value={this.state.date}
          >
            <DateOptions/>
          </SelectStyled>
          <SelectStyled
            name="githubUserId"
            onChange={this.handleChange}
            value={this.state.githubUserId}
          >
            <option value=""></option>
            <GithubUsers />
          </SelectStyled>
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
