require 'net/https'
require 'uri'

module GitHub
  class Service
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def spike
      uri = URI.parse('https://api.github.com/search/issues?q=type:issue+is:open+repo:department-of-veterans-affairs/vets.gov-team+created:>=2018-09-27')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(user.git_hub_username, user.personal_access_token)
      response = http.request(request)
    end
  end
end
