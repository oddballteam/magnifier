# frozen_string_literal: true

module Types
  # Input Object for mutating a Statistic.
  #
  # @see http://graphql-ruby.org/type_definitions/input_objects.html
  #
  class StatisticInput < BaseInputObject
    description 'Attributes for creating or updating a Statistic.'

    argument :source_id, String, required: true
    argument :source_type, String, required: true
    argument :source, String, required: true
    argument :state, String, required: true
    argument :repository_id, Int, required: true
    argument :organization_id, Int, required: true
    argument :url, String, required: true
    argument :title, String, required: true
    argument :source_created_at, String, required: true
    argument :source_updated_at, String, required: true
    argument :source_closed_at, String, required: false
  end
end
