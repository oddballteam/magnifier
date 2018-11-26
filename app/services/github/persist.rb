# frozen_string_literal: true

module Github
  class Persist
    attr_reader :user, :datetime, :service, :github_user, :org_id

    def initialize(user, datetime)
      @user = user
      @datetime = datetime
      @service = Github::Service.new(user, datetime)
      @github_user = find_github_user || create_github_user!
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

    private

    def find_github_user
      GithubUser.find_by(github_login: user.github_username)
    end

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

    def org_id!
      return user.organization_id if user.organization_id.present?

      raise Github::ServiceError, 'Missing user organization'
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
