import React from "react";
// see https://github.com/moment/moment/issues/2608#issuecomment-409240140
import moment from "moment";
window.moment = moment;

const WEEK = "week";
const startOfWeek = moment()
  .startOf(WEEK)
  .toISOString();
const options = [
  "day",
  WEEK,
  `last ${WEEK}`,
  "month",
  "last month",
  "quarter",
  "year"
];

function dateSinceToDatetime(dateSince) {
  const splitDateSince = dateSince.split(" ");

  if (splitDateSince[0] == "last") {
    return moment()
      .startOf(splitDateSince[1])
      .subtract(1, splitDateSince[1])
      .toISOString();
  } else {
    return moment()
      .startOf(dateSince)
      .toISOString();
  }
}

/*
@see http://momentjs.com/docs/#/manipulating/start-of/
@example format of value '2018-11-25T07:00:00.000Z'
*/
const DateOptions = () => {
  return options.map(dateSince => {
    const datetime = dateSinceToDatetime(dateSince);

    return (
      <option key={dateSince} value={datetime}>
        {`Start of ${dateSince}`}
      </option>
    );
  });
};

const datetimeToDate = datetime => moment(datetime).format("M/D/YY");
const datetimeToParams = datetime => moment(datetime).format("YYYY-MM-DD");
const dateToDayOfMonth = date => moment(date).format("dddd, M/D");

const DateToWeek = date => {
  const startDate = moment(date).startOf("isoWeek");
  const endDate = moment(date).endOf("isoWeek");

  return (
    <span>{`${dateToDayOfMonth(startDate)} - ${dateToDayOfMonth(
      endDate
    )}`}</span>
  );
};

const getDateFromUrl = urlParams => {
  const params = urlParams.split("?date=");
  const date = params[params.length - 1];

  return date;
};

export {
  startOfWeek,
  DateOptions,
  datetimeToDate,
  dateToDayOfMonth,
  DateToWeek,
  datetimeToParams,
  getDateFromUrl
};
