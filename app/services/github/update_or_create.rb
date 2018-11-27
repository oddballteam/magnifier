# frozen_string_literal: true

module Github
  class UpdateOrCreate
    attr_reader :issue, :github_user, :org_id, :repository_url, :repository_name, :issue_user, :issue_id, :merged

    def initialize(issue, github_user, org_id, merged: false)
      @issue = issue
      @github_user = github_user
      @org_id = org_id
      @repository_url = derive_repository_url
      @repository_name = derive_repository_name
      @issue_user = issue['user']
      @issue_id = issue['id'].to_s
      @merged = merged
    end

    # Based on the initialized issue and user, finds/creates a Repository record
    #
    # @return [Repository]
    #
    def repository!
      Repository.find_or_create_by!(url: repository_url) do |repo|
        repo.organization_id = org_id
        repo.name            = repository_name
      end
    end

    # Based on the initialized issue and user, does all of the following:
    #   - Creates/Updates a Statistic record
    #   - Finds/Creates associated Repository record
    #   - Associates the Statistic Record with its GithubUser record
    #
    # @return [Statistic]
    #
    def statistic!
      statistic = Statistic.find_by(source: Statistic::GITHUB, source_id: issue_id)

      if statistic
        statistic.tap { |stat| stat.update! issue_attributes }
      else
        statistic = Statistic.create! issue_attributes
      end

      associate_github_user_with statistic
    end

    private

    def derive_repository_url
      issue['repository_url'].gsub('api.', '').gsub('repos/', '')
    end

    def derive_repository_name
      repository_url.split('/').last
    end

    def issue_type
      issue['html_url'].include?('/issues/') ? Statistic::ISSUE : Statistic::PR
    end

    def associate_github_user_with(statistic)
      if statistic.github_users.include? github_user
        statistic
      else
        statistic.tap { |stat| stat.github_users << github_user }
      end
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def issue_attributes
      {
        source_id: issue_id,
        source_type: issue_type,
        source: Statistic::GITHUB,
        state: state,
        repository_id: repository!.id,
        organization_id: org_id,
        url: issue['html_url'],
        title: issue['title'],
        source_created_at: issue['created_at'],
        source_updated_at: issue['updated_at'],
        source_created_by: issue_user['id'],
        assignees: derive_assignees
      }
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    def state
      if merged
        Statistic::MERGED
      else
        issue['state']
      end
    end

    def derive_assignees
      assignees = []
      assignees = assignees << issue.dig('assignee', 'id')
      assignees = assignees << issue.dig('assignees').map { |assignee| assignee['id'] }

      assignees.flatten.compact.uniq
    end
  end
end
