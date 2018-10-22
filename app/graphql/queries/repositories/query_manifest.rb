# frozen_string_literal: true

module Queries
  module Repositories
    # Module that:
    #   - lists all of the Repository queries
    #   - assigns a field name to each query
    #   - maps a given field name to a resolver
    #
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :repositories, resolver: Queries::Repositories::RepositoriesQuery
        field :repository, resolver: Queries::Repositories::RepositoryQuery
      end
    end
  end
end
