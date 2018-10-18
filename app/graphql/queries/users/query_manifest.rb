# frozen_string_literal: true

require_relative 'all_users_query'
require_relative 'user_query'

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
        field :all_users, resolver: Queries::Users::AllUsersQuery
        field :user, resolver: Queries::Users::UserQuery
      end
    end
  end
end
