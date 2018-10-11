# GitHub Productivity Magnifier

A spike for a tool to reveal the individual and team contributions that employees have made to its projects.


## Front end
React-rails is configured, without react router currently

All components are visible in `app/javascript/components`

I've followed the paradigm introduced by Dan Abramov back in 2015 around smart and dumb components. Further reading on this topic is available [here](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0)

* To generate a react component *

`rails g react:component $COMPONENT_NAME`

Currently there is no connection from React to Rails, in a seperate PR, once the graphql stuff is implemented we can connect the apollo-provider to our graphql endpoint.

Currently using regular old css, but I brought in [Tail Wind CSS](https://tailwindcss.com/docs/what-is-tailwind/) to make things a little easier


## JS Linting

Prettier is currently configured with eslint, please google "Eslint format on save + your specific text editor" in order to take advantage of this

There are currently two scripts that can be ran

* `npm run eslint:fix` automatically reformats all js files
* `npm run eslint` - for use on CI, lints all files and shows results