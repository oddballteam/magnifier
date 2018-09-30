module GitHub
  # Note that all calls to the GitHub v3 API returns paginated results.
  #
  # @see https://developer.github.com/v3/#pagination
  #
  class Service
    BASE_URI = 'https://api.github.com'

    attr_reader :user, :auth

    def initialize(user)
      @user = user
      @auth = auth_credentials
    end

    # Proof of concept for testing that a private repository can be accessed,
    # through GitHub's v3 REST API, from a server side call.
    #
    # Testing involved deployment to Heroku, and basic auth requiring the users:
    #   - GitHub username
    #   - GitHub personal access token the user uses for accessing that repo
    #
    # @see app/models/user.rb for encrypting the personal_access_token
    # @see https://developer.github.com/v3/search/#search-issues
    #
    def spike
      endpoint = '/search/issues'
      repo     = 'department-of-veterans-affairs/vets.gov-team'
      date     = 3.days.ago.to_date.to_s
      query    = "q=type:issue+is:open+repo:#{repo}+created:>=#{date}"
      url      = "#{BASE_URI}#{endpoint}?#{query}"

      HTTParty.get(url, basic_auth: auth)
    end

    # @see https://developer.github.com/v3/orgs/#list-your-organizations
    #
    def user_organizations
      endpoint = '/user/memberships/orgs'
      url      = "#{BASE_URI}#{endpoint}"

      HTTParty.get(url, basic_auth: auth)
    end

    # @see https://developer.github.com/v3/repos/#list-organization-repositories
    #
    def repos_for(organization)
      endpoint = "/orgs/#{organization}/repos"
      url      = "#{BASE_URI}#{endpoint}"

      HTTParty.get(url, basic_auth: auth)
    end

    private

    def auth_credentials
      {
        username: user.git_hub_username,
        password: user.personal_access_token
      }
    end
  end
end
