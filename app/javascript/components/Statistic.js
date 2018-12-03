import React from "react";
import styled from 'styled-components';

const StatisticStyled = styled.div`
  border: 1px solid #DAE1E7;
  border-radius: 4px;
  color: #3D4852;
  padding: .75rem;
  margin: .25rem;
  margin-left: 0;
  max-width: 500px;
`;

const RepositoryStyled = styled.p`
  text-transform: uppercase;
  font-weight: 700;
  font-size: .65rem;
  color: black;
`;

const StatisticStateStyled = styled.p`
  text-transform: capitalize;
`;

class Statistic extends React.Component {
  render() {
    return (
      <StatisticStyled className='statistic'>
        <p className="pb-3">
          <a href={this.props.url} target="_blank">
            {this.props.title}
          </a>
        </p>
        <RepositoryStyled>{this.props.repository.name}</RepositoryStyled>
        <StatisticStateStyled>{`${this.props.state} ${this.props.sourceType}`} </StatisticStateStyled>
      </StatisticStyled>
    );
  }
}

export default Statistic;
