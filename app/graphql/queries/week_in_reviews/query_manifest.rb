# frozen_string_literal: true

module Queries
  module WeekInReviews
    # Module that:
    #   - lists all of the WeekInReview queries
    #   - assigns a field name to each query
    #   - maps a given field name to a resolver
    #
    module QueryManifest
      extend ActiveSupport::Concern

      included do
        field :week_in_review, resolver: Queries::WeekInReviews::WeekInReviewQuery
      end
    end
  end
end
