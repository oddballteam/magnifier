# frozen_string_literal: true

class MagnifierSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
