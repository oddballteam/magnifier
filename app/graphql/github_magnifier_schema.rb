# frozen_string_literal: true

class GithubMagnifierSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
