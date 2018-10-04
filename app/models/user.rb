class User < ApplicationRecord
  # @see https://github.com/attr-encrypted/attr_encrypted#usage
  #
  attr_encrypted :personal_access_token,
    key: Rails.application.secrets.encryption_key,
    encode: true
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
  def issues
    gh = GitHub::Service.new(self)
    resp = gh.spike
    resp['items']
  end
end
