# GitHub Productivity Magnifier

A tool to reveal the individual and team contributions that Oddball employees have made to its projects.

## Motivation

To learn new technologies through the development of a useful tool.  In this case, to learn and apply three different technologies:

- [GraphQL](https://graphql.org/) 
- React
- Ruby on Rails

Depending on the participant, some, but not all of these will be new technologies.

For GraphQL specifically, the intent is to:

- create a [GraphQL server in Ruby](https://www.howtographql.com/graphql-ruby/0-introduction/)
- use the GraphQL query language to query the GraphQL server from a React client 

## Business case 

### MVP - For Oddball managers and employees 

Updates Oddball leadership with the numbers around the ongoing contributions a given employee, or set of employees, is making to their project.  

Allows employees to focus their time on client work, vs. manually searching and compiling weekly statistics.
 
For an employee or team, it would provide:
  - the total number of, and links for, pull requests that were
    + created
    + created and worked
    + created, worked and closed
    + worked and closed
  - the total number of, and links for, issues that were
    + created
    + created and worked
    + created, worked and closed
    + worked and closed
  - displayed as:
    + raw numbers
    + links
    + perhaps graphical representations


### Post MVP - For Oddball business development

Enables Oddball to provide hard numbers to prospective clients around how impactful our employees have been on various projects.  

Provides numbers and graphs of the contributions that a set of Oddball employees have made, during a given period of time, compared to the total number of contributions that all contributors (oddball + non-oddball) made during that period of time.  

For example:

- In August 2018, for the Vets.gov project (which includes 10 repositories), Oddball employees comprised 12% of the overall engineering contributors, yet made 45% of the overall engineering contributions.
- In August 2018, for the Vets.gov project (which includes 10 repositories), Oddball employees merged 115 pull requests to production.  During the same time period, non-oddball employees merged 70 pull requests.  This represents an average of 5 closed pull requests, per Oddball employee, per week.  Compared to an average of 3 closed PRs for a non-oddball employee.


## MVP Implementation Considerations

### Getting the user data from GitHub

Some options:

1. Integrate GitHub's v3 REST API directly
    - I have a [successful spike](https://github.com/hpjaj/magnifier) in place for this
2. Use the [GitHub Octokit.rb gem](https://github.com/octokit/octokit.rb)
    - I spiked on this, and found the gem to be a confusing, inflexible, unnecessary extra layer of misdirection.
3. Integrate with GitHub's GraphQL API
    - I investigated this and there are some serious rate limiting concerns, both from a max limit standpoint, and from a notification standpoint.  Checking the rate limit must be a standalone request, and you are charged for it.

IMO option #1 is the best choice here.

### Getting access to private repos

In order to gain access to private repositories, user's will need to provide some form of authetication.  A few options are:

1. a personal access token
    - I have a [successful spike](https://github.com/hpjaj/magnifier) in place for this, including encrypting the token
2. an OAuth access token
    - This approach is [significantly more involved](https://developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/). It will also likley require the creation of a GitHub Application.

IMO option #1 is the best choice here.

## MVP - Part 1 - UI for predefined individual views

The expected UI flow would be: 

1. User defines their initial settings
    - enters their GitHub credentials
    - selects the GitHub organization(s) & repos they are part of, that will be analyzed
2. View the stats for the previous week for:
    - themself
    - any Oddball user


### User enters GitHub credentials

- User logs into a profile screen
- Enters GitHub username & personal access token (saved to the db in an encrypted column)

### User selects GitHub organization & repos

- User is prompted to select an organization(s) (e.g. `department-of-veterans-affairs`)
- They would likely be taken to another page (or modal) to make these selections
- User selects all of the repositories, from the chosen organizations, that they contribute to


### View a user's stats

Choose the user from a drop-down.

#### Resulting UI

Page automatically calcs and displays the pre-determined analytics:

  - the total number of, and links for, pull requests that were
    + created
    + created and worked
    + created, worked and closed
    + worked and closed
  - the total number of, and links for, issues that were
    + created
    + created and worked
    + created, worked and closed
    + worked and closed
  - displayed as:
    + raw numbers
    + links
    + perhaps graphical representations


## MVP - Part 2 - UI for predefined project views

Identical to individual views, except: 

1. user chooses from a list of projects (i.e. Vets.gov, Healthcare.gov, etc.), instead of a list of individual employees.

2. Does not provide links to each issue/PR


## Post MVP enhancement - UI for custom analytics

Envision a form, or a flow of forms, that ask the following questions.

### Select a time period

Form would offer options to:

  + customize start and end dates
  + choose from a set of defaults like:
    * this week
    * this month
    * last month
    * this quarter
    * last quarter
    * this year
    * last year

### Select a project

Form would:
  + allow user to choose from a list of projects
  + dynamically populate a list of associated repos, based on the selected project
  + allow user to check/uncheck repos


### Select Issues

  + Checkbox choices for
    * All
    * None
    * created
    * created and worked
    * created, worked and closed
    * worked and closed

### Select Pull Requests

+ Checkbox choices for
    * All
    * None
    * created
    * created and worked
    * created, worked and closed
    * worked and closed

### Select users or team

  + this is dynamically populated, based on the selected repos
  + cherry pick user(s) from list 
  + default group selections for:
    * all oddball employees on this project
    * all non-oddball employees on this project
    * all employees on this project


### Select users or team to compare with (optional)

  + this is dynamically populated, based on the selected repos 
  + cherry pick user(s) from list
  + default group selections for:
    * all oddball employees on this project
    * all non-oddball employees on this project
    * all employees on this project  

## Sample Usage

#### For one employee

- select this week
- select Vets.gov project
- select issues: worked & closed
- select pull requests: worked & closed
- select Harry Levine
- do not select comparison group

#### For one team

- select this week
- select Vets.gov project
- select issues: all
- select pull requests: all
- select Oddball Vets.gov team
- do not select comparison group

#### For Oddball team vs non-Oddball teams

- select last month
- select Vets.gov project
- select issues: none
- select pull requests: all
- select Oddball Vets.gov team
- select non-Oddball Vets.gov contributors


## Blue sky features

- admin interface to 
    - assign repos to projects
    - assign users to projects
    - add new GitHub domains
    - add new GitHub repos
