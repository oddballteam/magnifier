# frozen_string_literal: true

module Github
  class UpdateOrCreate
    attr_reader :issue, :user, :org_id, :repository_url, :repository_name, :issue_user, :issue_id, :merged

    def initialize(issue, user, merged: false)
      @issue = issue
      @user = user
      @org_id = org_id!(user.organization_id)
      @repository_url = derive_repository_url
      @repository_name = derive_repository_name
      @issue_user = issue['user']
      @issue_id = issue['id'].to_s
      @merged = merged
    end

    def repository!
      Repository.find_or_create_by!(url: repository_url) do |repo|
        repo.organization_id = org_id
        repo.name            = repository_name
      end
    end

    def github_user!
      GithubUser.find_or_create_by!(github_login: user.github_username) do |github_user|
        github_user.oddball_employee = true
        github_user.user_id          = user.id
        github_user.avatar_url       = issue_user['avatar_url']
        github_user.api_url          = issue_user['url']
        github_user.html_url         = issue_user['html_url']
        github_user.github_id        = issue_user['id']
      end
    end

    # - Creates/Updates a Statistic record
    # - Finds/Creates associated Repository record
    # - Finds/Creates associated GithubUser record
    #
    def statistic!
      statistic = Statistic.find_by(source: Statistic::GITHUB, source_id: issue_id)

      if statistic
        statistic.tap { |stat| stat.update! issue_attributes }
      else
        statistic = Statistic.create! issue_attributes

        associate_github_user_with statistic
      end
    end

    private

    def org_id!(organization_id)
      if organization_id.present?
        organization_id
      else
        raise Github::ServiceError, 'Missing user organization'
      end
    end

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
      statistic.tap do |stat|
        stat.github_users << github_user!
      end
    end

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
        source_created_by: issue_user['id']
      }
    end

    def state
      if merged
        Statistic::MERGED
      else
        issue['state']
      end
    end
  end
end
