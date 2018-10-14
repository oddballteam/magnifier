# frozen_string_literal: true

class MagnifierSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Queries::RootQuery)
end
