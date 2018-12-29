# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::UrlParser do
  let(:issue_url) { 'https://github.com/department-of-veterans-affairs/vets.gov-team/issues/15836' }
  let(:issue_url_parser) { Github::UrlParser.new(issue_url) }

  describe 'validations' do
    context 'with a valid url' do
      it 'sets #url to the passed url' do
        expect(issue_url_parser.url).to eq issue_url
      end
    end

    context 'URL does not contain "https://github.com/"' do
      let(:bad_url) { 'https://department-of-veterans-affairs/vets.gov-team/issues/15836' }

      it 'raises an error' do
        expect { Github::UrlParser.new(bad_url) }.to raise_error(
          Github::ServiceError,
          'URL must contain "https://github.com/"'
        )
      end
    end

    context 'URL is missing an element' do
      let(:bad_url) { 'https://github.com/department-of-veterans-affairs/issues/15836' }

      it 'raises an error' do
        expect { Github::UrlParser.new(bad_url) }.to raise_error(
          Github::ServiceError,
          'Invalid GitHub URL'
        )
      end
    end
  end

  describe '#owner' do
    it 'returns the :owner in the initialized URL' do
      expect(issue_url_parser.owner).to eq 'department-of-veterans-affairs'
    end
  end

  describe '#repo' do
    it 'returns the :repo in the initialized URL' do
      expect(issue_url_parser.repo).to eq 'vets.gov-team'
    end
  end

  describe '#type' do
    it 'returns the :type in the initialized URL' do
      expect(issue_url_parser.type).to eq 'issues'
    end
  end

  describe '#number' do
    it 'returns the :number in the initialized URL' do
      expect(issue_url_parser.number).to eq '15836'
    end
  end
end
