# frozen_string_literal: true

module Queries
  module Users
    # Module that:
    #   - lists all of the User queries
    #   - assigns a field name to each query
    #   - maps a given field name to a resolver
    #
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :user, resolver: Queries::Users::UserQuery
        field :users, resolver: Queries::Users::UsersQuery
      end
    end
  end
end
