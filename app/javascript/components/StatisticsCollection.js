import React from "react";
import { Query } from "react-apollo";
import Statistic from "./Statistic";
import styled from 'styled-components';

const StatisticContainerStyled = styled.div`
  display: flex;
  flex-wrap: wrap;
  flex-direction: column;
`;

const TitleStyled = styled.h3`
  padding: 2rem 0;
`;

const StatisticsCollection = ({ customQuery, githubUserId, date, title }) => (
  <Query
    query={customQuery}
    skip={!githubUserId}
    variables={{ githubUserId: parseInt(githubUserId), date: date }}
  >
    {({ loading, error, data }) => {
      if (loading) return <p>Loading...</p>;
      if (error) return <p>Error!</p>;
      if (data && data.statistics)
        return (
          <div>
            {githubUserId ? (
              <TitleStyled>{`${title} (${data.statistics.length})`}</TitleStyled>
            ) : (
              ""
            )}
            <StatisticContainerStyled>
              {data.statistics.map(statistic => (
                <Statistic {...statistic} key={statistic.sourceCreatedAt} />
              ))}
            </StatisticContainerStyled>
          </div>
        );

      return <div />;
    }}
  </Query>
);

export default StatisticsCollection;
