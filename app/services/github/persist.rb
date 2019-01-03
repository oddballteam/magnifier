# frozen_string_literal: true

module Github
  class Persist
    attr_reader :user, :datetime, :service, :github_user, :github_url, :org_id

    def initialize(user, datetime = nil, github_url: nil)
      @user = user
      @datetime = datetime
      @service = Github::Service.new(user, datetime)
      @github_user = find_github_user || create_github_user!
      @github_url = github_url
      @org_id = org_id!
    end

    # Calls Github::Service#issues_created and creates/updates associated
    # Statistic, GithubUser, and Repository records.
    #
    # @return [Array<Statistic>] An array of the created/updated Statistic records
    #
    def created_issues!
      update_or_create_stats!('issues_created')
    end

    # Calls Github::Service#issues_worked and creates/updates associated
    # Statistic, GithubUser, and Repository records.
    #
    # @return [Array<Statistic>] An array of the created/updated Statistic records
    #
    def worked_issues!
      update_or_create_stats!('issues_worked')
    end

    # Calls Github::Service#pull_requests_worked and creates/updates associated
    # Statistic, GithubUser, and Repository records.
    #
    # @return [Array<Statistic>] An array of the created/updated Statistic records
    #
    def worked_pull_requests!
      update_or_create_stats!('pull_requests_worked')
    end

    # Calls Github::Service#pull_requests_merged and creates/updates associated
    # Statistic, GithubUser, and Repository records.
    #
    # @return [Array<Statistic>] An array of the created/updated Statistic records
    #
    def merged_pull_requests!
      update_or_create_stats!('pull_requests_merged', merged: true)
    end

    def issue!
      response = service.issue(github_url)

      UpdateOrCreate.new(response.parsed_response, github_user, org_id).statistic!
    end

    def pull_request!
      response = service.pull_request(github_url)
      merged   = response.parsed_response['merged']

      UpdateOrCreate.new(response.parsed_response, github_user, org_id, merged: merged).statistic!
    end

    private

    def find_github_user
      GithubUser.find_by(github_login: user.github_username)
    end

    # rubocop:disable Metrics/MethodLength
    def create_github_user!
      response      = service.github_user_account
      response_user = response.parsed_response

      GithubUser.create!(
        github_login:     user.github_username,
        oddball_employee: true,
        user_id:          user.id,
        avatar_url:       response_user['avatar_url'],
        api_url:          response_user['url'],
        html_url:         response_user['html_url'],
        github_id:        response_user['id']
      )
    end
    # rubocop:enable Metrics/MethodLength

    def org_id!
      return find_or_create_org!.id if github_url.present?
      return user.organization_id if user.organization_id.present?

      raise Github::ServiceError, 'Missing user organization'
    end

    # Based on the initialized github_url, finds/creates an Organization record
    #
    # @return [Organization]
    #
    def find_or_create_org!
      parsed = Github::UrlParser.new(github_url)

      Organization.find_or_create_by!(name: parsed.owner) do |org|
        org.url = "https://github.com/#{parsed.owner}"
      end
    end

    def update_or_create_stats!(service_type, merged: false)
      response = service.send(service_type)
      items    = response.parsed_response['items']

      items.map do |item|
        UpdateOrCreate.new(item, github_user, org_id, merged: merged).statistic!
      end
    end
  end
end
