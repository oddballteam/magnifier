import React from "react";
import { Query } from "react-apollo";
import Statistic from "./Statistic";

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
          <div className="flex flex-wrap flex-col">
            {githubUserId ? (
              <h3 className="py-8 px-0">{`${title} (${data.statistics.length})`}</h3>
            ) : (
              ""
            )}
            <div>
              {data.statistics.map(statistic => (
                <Statistic {...statistic} key={statistic.sourceCreatedAt} />
              ))}
            </div>
          </div>
        );

      return <div />;
    }}
  </Query>
);

export default StatisticsCollection;
