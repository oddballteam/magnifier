# frozen_string_literal: true

module WeekInReviews
  class Boundries
    attr_reader :date, :start_date, :end_date, :start_time, :end_time

    # @param date [String] A date in the 'YYYY-MM-DD' format.
    #   Will accept a datetime string, as well.
    #
    def initialize(date)
      @date = validate!(date)
      @start_date = determine_start_date
      @end_date = determine_end_date
      @start_time = determine_start_time
      @end_time = determine_end_time
    end

    private

    def validate!(date)
      raise WeekInReviews::Error, 'Date must be a string' if date.class != String
      raise WeekInReviews::Error, 'Date must be a string' if Date.parse(date).class != Date

      Date.parse(date)
    end

    def determine_start_date
      date.beginning_of_week
    end

    def determine_end_date
      date.end_of_week
    end

    def determine_start_time
      start_date.beginning_of_day.iso8601
    end

    def determine_end_time
      end_date.end_of_day.iso8601
    end
  end
end
