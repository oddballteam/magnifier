# frozen_string_literal: true

class Repository < ApplicationRecord
  belongs_to :organization

  validates :name, :organization_id, presence: true
  validates :url, presence: true, uniqueness: true
end
