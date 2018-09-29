class User < ApplicationRecord
  attr_encrypted :personal_access_token, key: Rails.application.secrets.encryption_key, encode: true
end
