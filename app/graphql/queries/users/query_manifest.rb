# frozen_string_literal: true

require_relative 'all_users_query'
require_relative 'user_query'

module Queries
  module Users
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :all_users, resolver: Queries::Users::AllUsersQuery
        field :user, resolver: Queries::Users::UserQuery
      end
    end
  end
end
