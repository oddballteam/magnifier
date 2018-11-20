# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Configuration do
  let(:personal_access_token) { SecureRandom.hex(16) }
  let(:user) { create :user, personal_access_token: personal_access_token }

  describe '#set_options!' do
    it 'returns the required headers for the GitHub API', :aggregate_failures do
      results = Github::Configuration.new(user).set_options!
      headers = results[:headers]

      expect(headers['Accepts']).to be_present
      expect(headers['User-Agent']).to be_present
    end

    it 'returns the required basic authentication values', :aggregate_failures do
      results    = Github::Configuration.new(user).set_options!
      basic_auth = results[:basic_auth]

      expect(basic_auth[:username]).to be_present
      expect(basic_auth[:password]).to be_present
    end

    context 'with missing authentication criteria' do
      context 'with no personal_access_token' do
        it 'raises a Github::ServiceError with details', :aggregate_failures do
          invalid_user = build :user

          expect { Github::Configuration.new(invalid_user).set_options! }.to raise_error do |e|
            expect(e).to be_a(Github::ServiceError)
            expect(e.message).to eq 'Missing personal access token'
          end
        end
      end

      context 'with no user.github_username' do
        it 'raises a Github::ServiceError with details', :aggregate_failures do
          invalid_user = build(
            :user,
            personal_access_token: personal_access_token,
            github_username: nil
          )

          expect { Github::Configuration.new(invalid_user).set_options! }.to raise_error do |e|
            expect(e).to be_a(Github::ServiceError)
            expect(e.message).to eq 'Missing GitHub username'
          end
        end
      end
    end
  end

  describe '#results_size' do
    it 'returns the parameter for setting maximizing page results size' do
      puts 'TODO: Might need to be replaced with pagination at a later date'

      expect(Github::Configuration.new(user).results_size).to eq 'per_page=100'
    end
  end
end
