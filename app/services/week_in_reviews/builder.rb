# frozen_string_literal: true

module WeekInReviews
  class Builder
    attr_reader :user, :filter, :boundries, :week_in_review

    # @param user [User] A User record
    # @param date [String] A date that will define the WeekInReview's
    #   :start_date and :end_date.  Expects it in the 'YYYY-MM-DD' format.
    #   Will accept a datetime string, as well.
    #
    def initialize(user, date)
      @user = user
      @boundries = WeekInReviews::Boundries.new(date)
      @filter = WeekInReviews::Filter.new(validated_github_id!, date)
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

    def validated_github_id!
      github_user = GithubUser.find_by(user_id: user.id)

      raise WeekInReviews::Error, 'User does not have a GithubUser record' if github_user.nil?

      github_user.github_id
    end

    def create_week_in_review!
      @week_in_review = WeekInReview.create!(
        user: user,
        start_date: boundries.start_date,
        end_date: boundries.end_date
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
        Accomplishment.send(accomplishment_method, week_in_review.id, statistic.id, user.id)
      end
    end
  end
end
