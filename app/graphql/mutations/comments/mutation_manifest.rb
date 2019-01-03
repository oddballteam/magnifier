# frozen_string_literal: true

module Mutations
  module Comments
    # Module that:
    #   - lists all of the Comment mutations
    #   - assigns a field name to each mutation
    #   - maps a given field name to a resolver
    #
    module MutationManifest
      extend ActiveSupport::Concern

      included do
        field :create_comment, resolver: Mutations::Comments::CreateCommentMutation
        field :update_comment, resolver: Mutations::Comments::UpdateCommentMutation
      end
    end
  end
end
