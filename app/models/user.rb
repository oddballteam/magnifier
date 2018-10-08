# frozen_string_literal: true

class User < ApplicationRecord
  # @see https://github.com/attr-encrypted/attr_encrypted#usage
  #
  attr_encrypted :personal_access_token,
                 key: Rails.application.secrets.encryption_key,
                 encode: true
end
