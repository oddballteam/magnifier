namespace :github do
  desc <<-DESCRIPTION
    Fetchs all of the issue and pull request activity for our users.
    It then converts this data into the appropriate db records.

    By default, it will grab any acitivty since yesterday.  If you need
    to go back further, you can pass in a specific datetime.  The datetime
    must be in this format:

    '2018-11-26T00:00:00Z'

    Here is how to call this rake task, passing in a datetime:

    rake 'github:fetch_and_save_data[2018-11-26T00:00:00Z]'
  DESCRIPTION
  task :fetch_and_save_data, [:datetime] => :environment do |_t, args|
    yesterday = Date.yesterday.beginning_of_day.iso8601
    datetime  = args.datetime || yesterday
    users     = User.where.not(
      encrypted_personal_access_token: nil,
      github_username: nil,
      organization_id: nil
    )
    tracking = {
      datetime: datetime,
      users: users.count,
      created_issues: 0,
      worked_issues: 0,
      worked_pull_requests: 0,
      merged_pull_requests: 0,
      errors: 0
    }

    users.each do |user|
      persist = Github::Persist.new(user, datetime)

      created_issues       = persist.created_issues!
      worked_issues        = persist.worked_issues!
      worked_pull_requests = persist.worked_pull_requests!
      merged_pull_requests = persist.merged_pull_requests!

      tracking[:created_issues]       += created_issues.count
      tracking[:worked_issues]        += worked_issues.count
      tracking[:worked_pull_requests] += worked_pull_requests.count
      tracking[:merged_pull_requests] += merged_pull_requests.count
    rescue StandardError => e
      tracking[:errors] += 1
      message = "When fetching/saving GitHub data for user #{user.id}, experienced this error: #{e}"

      p message
      Rails.logger.error message
    end

    p tracking
    Rails.logger.info tracking.to_s
  end
end
