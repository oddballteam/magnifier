# frozen_string_literal: true

class MagnifierSchema < GraphQL::Schema
  mutation(Mutations::RootMutation)
  query(Queries::RootQuery)
end
