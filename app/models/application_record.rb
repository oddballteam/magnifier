# frozen_string_literal: true

# Base class from which all ActiveRecord models can inherit
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
