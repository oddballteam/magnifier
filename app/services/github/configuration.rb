# frozen_string_literal: true

module Github
  # Note that all calls to the GitHub v3 API returns paginated results.
  #
  # @see https://developer.github.com/v3/#pagination
  #
  class Configuration
    attr_reader :user

    def initialize(user)
      @user = user
    end

    # @see https://developer.github.com/v3/media/#request-specific-version
    # @see https://developer.github.com/v3/#user-agent-required
    #
    # rubocop:disable Metrics/MethodLength
    def set_options!
      auth_criteria_present!

      {
        headers: {
          'Accepts' => 'application/vnd.github.v3+json',
          'User-Agent' => 'Oddball'
        },
        basic_auth: {
          username: user.github_username,
          password: user.personal_access_token
        }
      }
    end
    # rubocop:enable Metrics/MethodLength

    # Many GitHub endpoints, including the Search Issues endpoint, can return
    # up to 100 results per page.  In order to return the max, the
    # per_page parameter must be passed.
    #
    # TODO: Maxing the page size at 100 is standing in place for implementing
    # a pagination solution.  At this point, as we will have daily cron jobs
    # for these endpoints, it is unrealistic to think that any user would have
    # more than 100 items returned in any of these endpoints, in a given day.
    # As such, pagination is not yet required.
    #
    # @see https://developer.github.com/v3/#pagination
    #
    def results_size
      'per_page=100'
    end

    private

    def auth_criteria_present!
      raise Github::ServiceError, 'Missing GitHub username' if user.github_username.blank?
      raise Github::ServiceError, 'Missing personal access token' if user.personal_access_token.blank?
    end
  end
end
