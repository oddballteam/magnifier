# frozen_string_literal: true

module Queries
  # This class inherits all of the necessary methods from
  # the GraphQL gem in order to create queries.
  #
  # @see https://github.com/rmosolgo/graphql-ruby/blob/master/lib/graphql/schema/resolver.rb
  #
  class BaseQuery < GraphQL::Schema::Resolver
  end
end
