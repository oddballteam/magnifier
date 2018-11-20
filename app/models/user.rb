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
  validates :github_username, uniqueness: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info["email"]
      user.first_name = auth.info["first_name"]
      user.last_name = auth.info["last_name"]
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end

  def org
    Organization.find_by id: organization_id
  end
end
