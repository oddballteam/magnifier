# frozen_string_literal: true

module Queries
  class RootQuery < Types::BaseObject
    include Queries::GithubUsers::QueryManifest
    include Queries::Organizations::QueryManifest
    include Queries::Repositories::QueryManifest
    include Queries::Statistics::QueryManifest
    include Queries::Users::QueryManifest
  end
end
