# frozen_string_literal: true

class Organization < ApplicationRecord
  has_many :statistics
  has_many :repositories

  validates :name, presence: true, uniqueness: true
  validates :url, presence: true, uniqueness: true
end
