# frozen_string_literal: true

require_relative 'all_repositories_query'
require_relative 'repository_query'

module Queries
  module Repositories
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :all_repositories, resolver: Queries::Repositories::AllRepositoriesQuery
        field :repository, resolver: Queries::Repositories::RepositoryQuery
      end
    end
  end
end
