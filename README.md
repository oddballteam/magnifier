# Magnifier  [![CircleCI](https://circleci.com/gh/oddballio/magnifier.svg?style=svg)](https://circleci.com/gh/oddballio/magnifier)

A tool to reveal the individual and team contributions that employees have made to its projects.

### Master Key

**You will need our master key** to work with the application.  More details can be found on our [Encrypted Credentials wiki page](https://github.com/oddballio/magnifier/wiki/Encrypted-Credentials). 

Here's how to get your master key setup:

1. To maintain security around this key, it will be shared via the [Keybase app](https://keybase.io/)
2. Ping our Slack `#oddball-tools` room, and request for someone to send you the key via Keybase
3. Create a file `config/master.key` file in your local Magnifier repo (this file is already part of our [`.gitignore` file](https://github.com/oddballio/magnifier/blob/master/.gitignore))
4. Add the `master` key to the file

Run `bin/setup` to install dependencies, copy git hooks and bootstrap local development db.

## Native Installation 

At its core, Magnifier is comprised of a Rails backend, and a React frontend.  Here are the associated dependencies you'll need:

- [Required Ruby version](https://github.com/oddballio/magnifier/blob/master/.ruby-version)
- [PostgreSQL](https://www.postgresql.org/)
- [Node.js](https://nodejs.org/en/)
- [Yarn](https://yarnpkg.com/en/docs/getting-started)

Once you've ensured that you have all of the above installed, here are the steps to getting the app up and running locally:

#### 1. Clone the repo

Clone the repo and `cd` into the `magnifier` directory

#### 2. Get the Master Key

You will need our **master key** to run the app. See the [Master Key](#master-key) section for more details.

#### 3. Install JS dependencies

```bash
yarn install
```

#### 4. Setup Rails

```bash
bin/setup
```

#### 5. Start the Rails server

```bash
rails s
```

#### 6. Open the app

Visit http://localhost:3000/

## Docker Installation

#### 1. Initial Docker build

```bash
RAILS_MASTER_KEY=$(cat config/master.key) docker-compose build
```

#### 2. Setup DB

```bash
RAILS_MASTER_KEY=$(cat config/master.key) docker-compose run web rake db:create
RAILS_MASTER_KEY=$(cat config/master.key) docker-compose run web rake db:schema:load
```

#### 3. Develop

```bash
RAILS_MASTER_KEY=$(cat config/master.key) docker-compose up
```

#### 4. Run the specs with guard

In a terminal in the same directory
```bash
RAILS_MASTER_KEY=$(cat config/master.key) docker-compose exec web guard
```

## Front end

React-rails is configured, without react router currently

All components are visible in `app/javascript/components`

I've followed the paradigm introduced by Dan Abramov back in 2015 around smart and dumb components. Further reading on this topic is available [here](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)

* To generate a react component *

`rails g react:component $COMPONENT_NAME`

Currently there is no connection from React to Rails, in a seperate PR, once the graphql stuff is implemented we can connect the apollo-provider to our graphql endpoint.

Currently using regular old css, but I brought in [Tail Wind CSS](https://tailwindcss.com/docs/what-is-tailwind/) to make things a little easier

### Routing

All routes are listed in `app/javascript/routes.js`. We are currently use `react-router@v4` be aware the API has changed significantly since 3.0, reading their quick start guide ([available_here](https://reacttraining.com/react-router/web/guides/philosophy)) will be immensely helpful.

There is a great example on how to do client side auth routing that we should bring in: https://reacttraining.com/react-router/web/example/auth-workflow

## JS Linting

Prettier is currently configured with eslint, please google "Eslint format on save + your specific text editor" in order to take advantage of this

There are currently two scripts that can be ran

* `npm run eslint:fix` automatically reformats all js files
* `npm run eslint` - for use on CI, lints all files and shows results

## Test Suite

Magnifier uses RSpec for its backend test suite.  

#### Run the specs

```
$ rspec
```

#### Run specs with Guard

Magnifier uses the [Guard::RSpec gem](https://github.com/guard/guard-rspec) to automatically run your specs.  To use it run:

```
$ bundle exec guard
```

# Deploying

## Build Docker iamge

Application can currently be built and run with docker.

To run the docker container locally, you'll need to inject the
`RAILS_MASTER_KEY` via the environment. After ensuring the key is present in
your current session with `env | grep RAILS_MASTER_KEY`, you can build the
container with: 
`RAILS_MASTER_KEY=$(cat config/master.key) docker-compose build`

The first time building will take a few minutes, based on your internet speed. 

After the container has been built, run it locally with: 

`RAILS_MASTER_KEY=$(cat config/master.key) docker-compose up`

## Interacting with Docker container locally

For the following commands, first use `docker ps` to list the active containers and get the name of the container

*Run a bash console*

`docker exec -it <container name> /bin/bash` - to get bash shell

*Run a rails console*

`docker exec -it <container name> bundle exec rails c`

Currently we are using rails to serve the static assets, long term this will probably need to change and switch to using nginx or something similar

## Production Setup

We are currently using AWS ECS' Fargate offering, with RDS and public and private subnets

```
                            +--------------------+
+-----------------+         |                    |
|                 |         |                    |
|                 |         | Public Internet    |
|  AWS Fargate    <---------+                    |
|                 |         |                    |
|                 |         |                    |
+--------+--------+         |                    |
         |                  +--------------------+
         |
         |
         v
+--------+--------+
|                 |
|  DB             |
|                 |
|                 |
|                 |
+-----------------+
```

All code is visible in `/infrastructure`

Logs are currently being streamed to AWS Cloudwatch and tagged by the ECS task definition ID.
By navigating to cloudwatch here: https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logStream:group=/ecs/magnifier , and selecting the latest stream you can see the current production logs

In order to run a one-off task we currently have a `magnifier-single-task` service created with a desired task count of 0, simply tweak the command in `infrastructure/magnifier-single-task.json.tpl` and adjust the `desired_count` in `aws_ecs_service.magnifier_single_task` in infrastructure/main.tf to 1, `terraform plan` `terraform apply` and watch your new instance come online and [view the logs in cloudwatch](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1#logStream:group=/ecs/magnifier-single-task)

That task is currently configured to run `rails db:migrate` tweak it to whatever you like, and it will allow for arbitrary execution on aws