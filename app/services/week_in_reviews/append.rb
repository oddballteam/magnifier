# frozen_string_literal: true

module WeekInReviews
  class Append
    attr_reader :statistic, :week_in_review, :user, :hub_id, :boundries, :start_time, :end_time

    def initialize(statistic, week_in_review, user)
      @statistic = statistic
      @week_in_review = week_in_review
      @user = user
      @hub_id = GithubUser.find_by(user_id: user.id)&.github_id
      @boundries = WeekInReviews::Boundries.new(week_in_review.start_date.to_s)
      @start_time = boundries.start_time
      @end_time = boundries.end_time
    end

    # Creates the correct Accomplishment records for the initialized Statistic,
    # WeekInReview, and User.
    #
    # @return [Array<Accomplishmet>] An array of the newly created Accomplishments
    #
    def new_accomplishments!
      case statistic.source_type
      when Statistic::ISSUE
        create_issue_accomplishments!
      when Statistic::PR
        create_pull_request_accomplishments!
      end
    end

    private

    def create_issue_accomplishments!
      accomplishments = []
      accomplishments << create('created_issue!') if user_created? && created_during_wir?
      accomplishments << create('worked_issue!') if updated_during_wir?
      accomplishments << create('closed_issue!') if closed_during_wir?
      accomplishments
    end

    def create_pull_request_accomplishments!
      accomplishments = []
      accomplishments << create('created_pr!') if created_during_wir?
      accomplishments << create('worked_pr!') if updated_during_wir?
      accomplishments << create('merged_pr!') if closed_during_wir? && merged?
      accomplishments
    end

    def create(accomplishment_method)
      Accomplishment.send(
        "create_#{accomplishment_method}",
        week_in_review.id,
        statistic.id,
        user.id
      )
    end

    def user_created?
      statistic.source_created_by == hub_id
    end

    def created_during_wir?
      return unless statistic.source_created_at >= start_time

      statistic.source_created_at <= end_time
    end

    def updated_during_wir?
      return unless statistic.source_updated_at >= start_time

      statistic.source_updated_at <= end_time
    end

    def closed_during_wir?
      return unless statistic.source_closed_at
      return unless statistic.source_closed_at >= start_time

      statistic.source_closed_at <= end_time
    end

    def merged?
      statistic.state == Statistic::MERGED
    end
  end
end
