# frozen_string_literal: true

module Github
  # Note that all calls to the GitHub v3 API returns paginated results.
  #
  # @see https://developer.github.com/v3/#pagination
  #
  class Service
    BASE_URI = 'https://api.github.com'
    SEARCH_ENDPOINT = "#{BASE_URI}/search/issues"

    attr_reader :configuration, :options, :results_size, :user, :datetime, :username, :org

    # @param user [User] A User record
    # @param datetime [String] Datetime string in the iso8601 format: '2018-11-26T00:00:00Z'
    #
    def initialize(user, datetime = nil)
      @configuration = Github::Configuration.new(user)
      @options = configuration.set_options!
      @results_size = configuration.results_size
      @user = user
      @datetime = datetime
      @username = user.github_username
      @org = user.org&.name
    end

    # Fetches all of the issues that:
    #   - the user has created
    #   - stem from any of the repositories in the user's organization
    #   - have a created_at datetime >= the passed datetime
    #   - have a state of open or closed
    #
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/search/#search-issues
    # @see https://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response
    #
    def issues_created
      search_criteria_present!

      query    = "q=type:issue+org:#{org}+author:#{username}+created:>=#{datetime}"
      url      = "#{SEARCH_ENDPOINT}?#{results_size}&#{query}"
      response = HTTParty.get url, options

      handle! response
    end

    # Fetches all of the issues that:
    #   - the user is assigned to
    #   - stem from any of the repositories in the user's organization
    #   - have an updated datetime >= the passed datetime
    #   - have a state of open or closed
    #
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/search/#search-issues
    # @see https://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response
    #
    def issues_worked
      search_criteria_present!

      query    = "q=type:issue+org:#{org}+assignee:#{username}+updated:>=#{datetime}"
      url      = "#{SEARCH_ENDPOINT}?#{results_size}&#{query}"
      response = HTTParty.get url, options

      handle! response
    end

    # Fetches all of the pull requests that:
    #   - the user created
    #   - stem from any of the repositories in the user's organization
    #   - have an updated datetime >= the passed datetime
    #   - have a state of open or closed
    #
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/search/#search-issues
    # @see https://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response
    #
    def pull_requests_worked
      search_criteria_present!

      query    = "q=type:pr+org:#{org}+author:#{username}+updated:>=#{datetime}"
      url      = "#{SEARCH_ENDPOINT}?#{results_size}&#{query}"
      response = HTTParty.get url, options

      handle! response
    end

    # Fetches all of the pull requests that:
    #   - the user created
    #   - stem from any of the repositories in the user's organization
    #   - have an updated datetime >= the passed datetime
    #   - have a state of merged
    #
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/search/#search-issues
    # @see https://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response
    #
    def pull_requests_merged
      search_criteria_present!

      query    = "q=type:pr+is:merged+org:#{org}+author:#{username}+updated:>=#{datetime}"
      url      = "#{SEARCH_ENDPOINT}?#{results_size}&#{query}"
      response = HTTParty.get url, options

      handle! response
    end

    # Gets all the organizations that the initialized user belong to.
    #
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/orgs/#list-your-organizations
    # @see https://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response
    #
    def user_organizations
      endpoint = '/user/memberships/orgs'
      url      = "#{BASE_URI}#{endpoint}?#{results_size}"
      response = HTTParty.get url, options

      handle! response
    end

    # Gets all the repositories that belong to the passed organization.
    #
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/repos/#list-organization-repositories
    # @see https://www.rubydoc.info/github/jnunemaker/httparty/HTTParty/Response
    #
    def repos_for(organization)
      endpoint = "/orgs/#{organization}/repos"
      url      = "#{BASE_URI}#{endpoint}?#{results_size}"
      response = HTTParty.get url, options

      handle! response
    end

    # Fetches publicly available information for user's GitHub account.
    #
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/users/#get-a-single-user
    #
    def github_user_account
      endpoint = "/users/#{username}"
      url      = "#{BASE_URI}#{endpoint}"
      response = HTTParty.get url, options

      handle! response
    end

    # Gets a single GitHub issue with the passed URL. GitHub API endpoint is:
    # GET /repos/:owner/:repo/issues/:number
    #
    # @param github_url [String] The GitHub URL for the issue, i.e.
    #   'https://github.com/department-of-veterans-affairs/vets.gov-team/issues/15836'
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/issues/#get-a-single-issue
    #
    def issue(github_url)
      parsed   = Github::UrlParser.new(github_url)
      endpoint = "/repos/#{parsed.owner}/#{parsed.repo}/issues/#{parsed.number}"
      url      = "#{BASE_URI}#{endpoint}"
      response = HTTParty.get url, options

      handle! response
    end

    # Gets a single GitHub pull request with the passed URL. GitHub API endpoint is:
    # GET /repos/:owner/:repo/pulls/:number
    #
    # @param github_url [String] The GitHub URL for the pull request, i.e.
    #   'https://github.com/department-of-veterans-affairs/vets-api/pull/2682'
    # @return [HTTParty::Response]
    # @see https://developer.github.com/v3/pulls/#get-a-single-pull-request
    #
    def pull_request(github_url)
      parsed   = Github::UrlParser.new(github_url)
      endpoint = "/repos/#{parsed.owner}/#{parsed.repo}/pulls/#{parsed.number}"
      url      = "#{BASE_URI}#{endpoint}"
      response = HTTParty.get url, options

      handle! response
    end

    private

    def search_criteria_present!
      raise Github::ServiceError, 'Missing user organization' if org.blank?
      raise Github::ServiceError, 'Missing datetime' if datetime.blank?
    end

    def handle!(response)
      if response.code.to_i == 200
        response
      else
        raise Github::ServiceError, {
          status: response.code,
          body: response.parsed_response,
          user_id: user.id,
          source: self.class.to_s
        }.to_json
      end
    end
  end
end
