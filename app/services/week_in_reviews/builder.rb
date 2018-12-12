# frozen_string_literal: true

module WeekInReviews
  class Builder
    attr_reader :user, :date, :start_date, :end_date, :filter, :week_in_review

    # @param user [User] A User record
    # @param date [String] A date that will define the WeekInReview's
    #   :start_date and :end_date.  Expects it in the 'YYYY-MM-DD' format.
    #   Will accept a datetime string, as well.
    #
    def initialize(user, date)
      @user = user
      @date = validate_date!(date)
      @start_date = determine_start_date
      @end_date = determine_end_date
      @filter = WeekInReviews::Filter.new(validated_github_id!, start_time, end_time)
    end

    # Creates a WeekInReview record and all of the week's Accomplishments,
    # for the initialized user and date.
    #
    # @return [WeekInReview]
    #
    def assemble!
      create_week_in_review!
      surface_accomplishments!
      week_in_review
    end

    private

    def validate_date!(date)
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

    def validated_github_id!
      github_user = GithubUser.find_by(user_id: user.id)

      raise WeekInReviews::Error, 'User does not have a GithubUser record' if github_user.nil?

      github_user.github_id
    end

    def start_time
      start_date.beginning_of_day.iso8601
    end

    def end_time
      end_date.end_of_day.iso8601
    end

    def create_week_in_review!
      @week_in_review = WeekInReview.create!(
        user: user,
        start_date: start_date,
        end_date: end_date
      )
    end

    def surface_accomplishments!
      create_accomplishments! 'created_issues', 'create_created_issue!'
      create_accomplishments! 'worked_issues', 'create_worked_issue!'
      create_accomplishments! 'closed_issues', 'create_closed_issue!'
      create_accomplishments! 'created_pull_requests', 'create_created_pr!'
      create_accomplishments! 'worked_pull_requests', 'create_worked_pr!'
      create_accomplishments! 'merged_pull_requests', 'create_merged_pr!'
    end

    def create_accomplishments!(filter_method, accomplishment_method)
      statistics = filter.send(filter_method)

      statistics.each do |statistic|
        Accomplishment.send(accomplishment_method, week_in_review, statistic, user)
      end
    end
  end
end
