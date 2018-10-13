# frozen_string_literal: true

module Types
  # All logic for the individual queries lies in the included
  # modules.  For example, all of the query logic for Organizations
  # resides in the Types::QueryTypes::Organization module.
  #
  class QueryType < Types::BaseObject
    include Types::QueryTypes::Organization
    include Types::QueryTypes::Repository
  end
end
