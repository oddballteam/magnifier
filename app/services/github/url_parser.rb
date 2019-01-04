# frozen_string_literal: true

module Github
  # Parses the passed GitHub URL into its core elements, namely its:
  #   - owner
  #   - repo
  #   - type
  #   - number
  #
  class UrlParser
    attr_reader :url, :owner, :repo, :type, :number

    def initialize(url)
      @url = validate!(url)
      @owner, @repo, @type, @number = derived_url_elements
    end

    private

    def validate!(url)
      raise Github::ServiceError, 'URL must contain "https://github.com/"' unless valid_domain?(url)
      raise Github::ServiceError, 'Invalid GitHub URL' unless valid_elements?(url)

      url
    end

    def valid_domain?(url)
      url.include? 'https://github.com/'
    end

    # A valid split GitHub URL looks like this:
    # ["https:", "", "github.com", "department-of-veterans-affairs", "vets.gov-team", "issues", "15836"]
    #
    def valid_elements?(url)
      url.split('/').length == 7
    end

    # @return [Array] Array of the URL's elements, less empty strings and domain.
    #   For example:
    #   ["department-of-veterans-affairs", "vets.gov-team", "issues", "15836"]
    #
    def derived_url_elements
      url.split('/').reject { |element| element == '' }.slice(2, 4)
    end
  end
end
