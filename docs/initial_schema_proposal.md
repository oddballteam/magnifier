# Schema Proposal for Persisting Statistics

## Goal

The MVP goal is for the resulting schema to be able to answer the following questions for: 

- a given employee
- for the current week

#### Issues

- [x] How many issues did they create?
- [x] How many issues did they work?
- [x] How many issues did they close?
- [x] What are the links to each one of the above?

#### Pull Requests

- [x] How many PRs did they create?
- [x] How many PRs did they work?
- [x] How many PRs did they close?
- [x] What are the links to each one of the above?

#### Edge Cases

- [x] Any one of the above, where more than one person worked on the issue?

### Post MVP Goal

- [x] Same questions, for a group of employees (i.e. on a given project)
- [x] Same questions, for a dynamic period of time (i.e. last week, last month, etc.)
- [x] Compare oddball vs. non-oddball stats

## Database Tables

We would need four tables, two of which have a many-to-many relationship between them, using the [`has_and_belongs_to_many` implementation](https://guides.rubyonrails.org/association_basics.html#the-has-and-belongs-to-many-association):

**Statistic** table

| Column | Type | Examples |
| --------| -----| -- |
| string |  source_id | '1234'
| string |  source_type | 'issue', 'pull_request'
| string | source | 'github', 'jira'
| string |  state | 'open', 'closed', 'merged'
| integer |  repository_id | 1
| integer |  organization_id | 1 
| string |  url | 
| string |  title |
| string | source_created_at |
| string | source_updated_at |
| string | source_closed_at | '2018-10-08T20:31:41Z'


**GithubUser** table

| Column | Type |
| --------| -----|
| integer | user_id |
| string | github_login |
| string | avatar_url |
| string | api_url |
| string | html_url |
| integer | github_id |
| boolean | oddball_employee |

**Repository** table

| Column | Type | Examples |
| --------| -----| -- |
| string | name | 'vets-api'
| string | url | 
| integer | organization_id |

**Organization** table

| Column | Type | Examples |
| --------| -----| -- |
| string | name | 'department-of-veterans-affairs'
| string | url | 


## Sample Data set

#### Statistics

```ruby 
[
  #<Statistic> {
    :source_id         => "367942274",
    :source_type       => "issue",
    :source            => "github",
    :state             => "open",
    :repository_id     => 19,
    :organization_id   => 21,
    :url               => "https://api.github.com/repos/department-of-veterans-affairs/vets.gov-team/issues/14066",
    :title             => "Clean up URL parameters in View Settings",
    :source_created_at => "2018-10-08T20:31:41Z",
    :source_updated_at => "2018-10-08T20:31:42Z",
    :source_closed_at  => nil,
  },
  #<Statistic> {
    :source_id         => "367942274",
    :source_type       => "pull_request",
    :source            => "github",
    :state             => "merged",
    :repository_id     => 19,
    :organization_id   => 21,
    :url               => "https://api.github.com/repos/department-of-veterans-affairs/vets.gov-team/issues/14047",
    :title             => "Link on Housing hub in yellow homeless box needs to be populated",
    :source_created_at => "2018-10-07T20:31:41Z",
    :source_updated_at => "2018-10-09T20:31:42Z",
    :source_closed_at  => "2018-10-09T50:31:42Z",
  }
]
```

#### GithubUsers

```ruby 
[
  #<GithubUser> {
    :user_id          => 18,
    :github_login     => "jsmith",
    :avatar_url       => "https://avatars2.githubusercontent.com/u/24525739?v=4",
    :api_url          => "https://api.github.com/users/nedierecel",
    :html_url         => "https://github.com/nedierecel",
    :github_id        => 24525739,
    :oddball_employee => true,
  },
  #<GithubUser> {
    :user_id          => nil,
    :github_login     => "bethpotts",
    :avatar_url       => "https://avatars1.githubusercontent.com/u/14881910?v=4",
    :api_url          => "https://api.github.com/users/bethpotts",
    :html_url         => "https://github.com/bethpotts",
    :github_id        => 14881910,
    :oddball_employee => false,
  }
]
```

#### Repositories

```ruby 
[
  #<Repository> {
    :name            => "vets-api",
    :url             => "https://github.com/department-of-veterans-affairs/vets-api",
    :organization_id => 21,
  },
  #<Repository> {
    :name            => "statsd",
    :url             => "https://github.com/etsy/statsd",
    :organization_id => 22,
  }
]
```

#### Organizations

```ruby 
[
  #<Organization> {
    :name       => "department-of-veterans-affairs",
    :url        => "https://github.com/department-of-veterans-affairs",
  },
  #<Organization> {
    :name       => "etsy",
    :url        => "https://github.com/etsy",
  }
]
```

#### Users

```ruby 
[
  #<User> {
    :first_name                         => "John",
    :last_name                          => "Smith",
    :email                              => "john@example.com",
    :encrypted_personal_access_token    => nil,
    :encrypted_personal_access_token_iv => nil,
    :github_username                   => "jsmith"
  },
  #<User> {
    :first_name                         => "Susan",
    :last_name                          => "Williams",
    :email                              => "susan@example.com",
    :encrypted_personal_access_token    => nil,
    :encrypted_personal_access_token_iv => nil,
    :github_username                   => "suzy"
  }
]
```



## Relationships

```ruby
class Statistic < ApplicationRecord
  has_and_belongs_to_many :github_users 
  belongs_to :organization
  
  # Does not belongs_to :repository b/c
  # JIRA issues will not consistently identify
  # an associated repository
  #  
  # Instead, we can have a method on this class
  # for fetching the associated repository, if
  # one is present, e.g.
  # 
  def repository
    return unless repository_id
    
    Repository.find_by(id: repository_id)
  end
end
 
class GithubUser < ApplicationRecord
  has_and_belongs_to_many :statistics
  #
  # Will *not* belongs_to a :user because some
  # GithubUsers may not be Oddball employees,
  # and thereby will not have a User record.
  # 
  # Instead, will offer methods like these:
  # 
  def user
    # logic to search an existing record, 
    # by its user_id attr
  end
  
  def self.user(user_id)
    # logic to search by a passed User.id
  end
end

class Repository < ApplicationRecord
  belongs_to :organization
end

class Organization < ApplicationRecord
  has_many :statistics
  has_many :repositories
end
 
class User < ApplicationRecord
  # Will *not* have a Rails association to  
  # GithubUser b/c of the above.  Instead, 
  # would have a class method for that
  # on GithubUser
end
```

## Indexes

Add indexes to the foreign key relationships for performance.
