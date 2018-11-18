# frozen_string_literal: true

module Github
  class Persist
    attr_reader :user, :datetime, :service

    def initialize(user, datetime)
      @user = user
      @datetime = datetime
      @service = Github::Service.new(user, datetime)
    end

    def created_issues!
      update_or_create_stats!('issues_created')
    end

    def worked_issues!
      update_or_create_stats!('issues_worked')
    end

    def worked_pull_requests!
      update_or_create_stats!('pull_requests_worked')
    end

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
