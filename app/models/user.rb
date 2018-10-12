# frozen_string_literal: true

# Provides a class to wrap User behavior
#
class User < ApplicationRecord
  # @see https://github.com/attr-encrypted/attr_encrypted#usage
  # @see https://github.com/attr-encrypted/attr_encrypted/issues/311
  attr_encrypted :personal_access_token,
                 key: Rails.application.credentials.encryption_key,
                 encode: true

  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :github_username, presence: true, uniqueness: true
end
