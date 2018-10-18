# frozen_string_literal: true

# A GraphQL schema is a web of interconnected types, and it has a
# few starting points for discovering the elements of that web.
#
# We are using Root types (query, mutation, and subscription) as
# the entry points for queries and mutations to the system.
#
# @see http://graphql-ruby.org/schema/definition.html
#
class MagnifierSchema < GraphQL::Schema
  mutation(Mutations::RootMutation)
  query(Queries::RootQuery)
end
