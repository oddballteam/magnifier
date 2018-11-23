# frozen_string_literal: true

module Github
  class Persist
    attr_reader :user, :datetime, :service

    def initialize(user, datetime)
      @user = user
      @datetime = datetime
      @service = Github::Service.new(user, datetime)
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

    def update_or_create_stats!(service_type, merged: false)
      response = service.send(service_type)
      items    = response.parsed_response['items']

      items.map do |item|
        UpdateOrCreate.new(item, user, merged: merged).statistic!
      end
    end
  end
end
