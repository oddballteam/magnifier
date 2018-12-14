# frozen_string_literal: true

module WeekInReviews
  class Filter
    attr_reader :github_user_id, :start_time, :end_time

    def initialize(github_user_id, start_time, end_time)
      @github_user_id = github_user_id
      @start_time = validate_time!(start_time)
      @end_time = validate_time!(end_time)
    end

    def created_issues
      Statistic
        .of_type(Statistic::ISSUE)
        .of_state([Statistic::OPEN, Statistic::CLOSED])
        .created_by(github_user_id)
        .created_after(start_time)
        .created_before(end_time)
    end

    def worked_issues
      Statistic
        .of_type(Statistic::ISSUE)
        .of_state([Statistic::OPEN, Statistic::CLOSED])
        .assigned_to(github_user_id)
        .updated_after(start_time)
        .updated_before(end_time)
    end

    def closed_issues
      Statistic
        .of_type(Statistic::ISSUE)
        .of_state(Statistic::CLOSED)
        .assigned_to(github_user_id)
        .closed_after(start_time)
        .closed_before(end_time)
    end

    def created_pull_requests
      Statistic
        .of_type(Statistic::PR)
        .of_state([Statistic::OPEN, Statistic::CLOSED, Statistic::MERGED])
        .created_by(github_user_id)
        .created_after(start_time)
        .created_before(end_time)
    end

    def worked_pull_requests
      Statistic
        .of_type(Statistic::PR)
        .of_state([Statistic::OPEN, Statistic::CLOSED, Statistic::MERGED])
        .created_by(github_user_id)
        .updated_after(start_time)
        .updated_before(end_time)
    end

    def merged_pull_requests
      Statistic
        .of_type(Statistic::PR)
        .of_state(Statistic::MERGED)
        .created_by(github_user_id)
        .closed_after(start_time)
        .closed_before(end_time)
    end

    private

    def validate_time!(time)
      raise WeekInReviews::Error, 'Time must be a string' if time.class != String
      raise WeekInReviews::Error, 'Time must be a string' if Time.parse(time).class != Time

      Time.parse(time).iso8601
    end
  end
end
