# frozen_string_literal: true

module Queries
  class RootQuery < Types::BaseObject
    include Queries::Organizations::QueryManifest
    include Queries::Repositories::QueryManifest
  end
end
