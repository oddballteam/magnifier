# rubocop:disable Layout/EmptyLines

#################  Reset Database  ##################

WeekInReview.destroy_all
Statistic.destroy_all
GithubUser.delete_all
User.delete_all
Repository.delete_all
Organization.delete_all


#################  Organizations  ##################

orgs = [
  {
    name: 'department-of-veterans-affairs',
    url: 'https://github.com/department-of-veterans-affairs'
  },
  {
    name: 'etsy',
    url: 'https://github.com/etsy'
  }
]

orgs.each do |org|
  Organization.create org
end

dova = Organization.find_by(name: 'department-of-veterans-affairs')
etsy = Organization.find_by(name: 'etsy')


#################  Repositories  ##################

repos = [
  {
    name: 'vets-api',
    url: 'https://github.com/department-of-veterans-affairs/vets-api',
    organization_id: dova.id
  },
  {
    name: 'statsd',
    url: 'https://github.com/etsy/statsd',
    organization_id: etsy.id
  }
]

repos.each do |repo|
  Repository.create repo
end


#################  Users  ##################

people = [
  {
    first_name: 'John',
    last_name: 'Smith',
    email: 'john@example.com',
    github_username: 'jsmith',
    organization_id: dova.id
  },
  {
    first_name: 'Susan',
    last_name: 'Williams',
    email: 'susan@example.com',
    github_username: 'suzy',
    organization_id: etsy.id
  }
]

people.each do |person|
  User.create person
end

john = User.find_by(github_username: 'jsmith')
suzy = User.find_by(github_username: 'suzy')


#################  GithubUsers  ##################

gh_users = [
  {
    user_id: john.id,
    github_login: 'jsmith',
    avatar_url: 'https://avatars2.githubusercontent.com/u/24525739?v=4',
    api_url: 'https://api.github.com/users/nedierecel',
    html_url:  'https://github.com/nedierecel',
    github_id: 24525739,
    oddball_employee: true
  },
  {
    github_login: 'bethpotts',
    avatar_url: 'https://avatars1.githubusercontent.com/u/14881910?v=4',
    api_url: 'https://api.github.com/users/bethpotts',
    html_url:  'https://github.com/bethpotts',
    github_id: 14881910,
    oddball_employee: false
  }
]

gh_users.each do |user|
  GithubUser.create user
end

smitty = GithubUser.find_by(github_login: 'jsmith')
beth   = GithubUser.find_by(github_login: 'bethpotts')


#################  Statistics  ##################

stats = [
  {
    source_id: '367942274',
    source_type: 'issue',
    source: 'github',
    state: 'open',
    repository_id: Repository.first.id,
    organization_id: dova.id,
    url: 'https://github.com/department-of-veterans-affairs/vets.gov-team/issues/14066',
    title: 'Clean up URL parameters in View Settings',
    source_created_at: '2018-10-08T20:31:41Z',
    source_updated_at: '2018-10-08T20:31:42Z',
    source_created_by: 123456789
  },
  {
    source_id: '367942274',
    source_type: 'pull_request',
    source: 'github',
    state: 'merged',
    repository_id: Repository.first.id,
    organization_id: dova.id,
    url: 'https://github.com/department-of-veterans-affairs/vets.gov-team/issues/14047',
    title: 'Link on Housing hub in yellow homeless box needs to be populated',
    source_created_at: '2018-10-07T20:31:41Z',
    source_updated_at: '2018-10-09T20:31:42Z',
    source_closed_at: '2018-10-09T50:31:42Z',
    source_created_by: beth.github_id,
    assignees: [beth.github_id]
  }
]

stats.each do |stat|
  Statistic.create stat
end

issue = Statistic.first
pr = Statistic.last


#################  GithubUsersStatistics  ##################

smitty.statistics << issue
beth.statistics << pr


#################  WeekInReviews  ##################

date = pr.source_updated_at
week_in_review = ::WeekInReviews::Builder.new(suzy, date).assemble!


#################  Accomplishments  ##################

week_in_review.accomplishments


#################  Comments  ##################

comments = [
  { type: :concerns, body: 'some concern' },
  { type: :oddball_team, body: 'some oddball team thing' },
  { type: :project_team, body: 'some project team thing' },
  { type: :week_go, body: 'some week go thing' }
]

comments.each do |comment|
  Comment.create!(
    week_in_review_id: week_in_review.id,
    user_id: suzy.id,
    body: comment[:body],
    type: comment[:type]
  )
end


#################  Reporting  ##################

p 'Seeding complete. Created:'
p "#{Organization.count} Organizations"
p "#{Repository.count} Repositories"
p "#{User.count} Users"
p "#{GithubUser.count} GithubUsers"
p "#{Statistic.count} Statistics"
p "#{WeekInReview.count} WeekInReviews"
p "#{Accomplishment.count} Accomplishments"
p "#{Comment.count} Comments"

# rubocop:enable Layout/EmptyLines
