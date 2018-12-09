# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      user = create :user
      expect(user).to be_valid
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:github_username) }
  end

  describe 'associations' do
    it { should have_many(:week_in_reviews) }
    it { should have_many(:accomplishments) }
  end

  describe 'from_omniauth' do
    it 'has a method that requires an auth obj from omniauth2' do
      count = User.count
      token = SecureRandom.hex
      authmock = OmniAuth::AuthHash.new
      authmock.info = {
        first_name: 'Jane',
        last_name: 'Doe',
        name: 'Jane Doe',
        email: 'jane.doe@gmail.com'
      }
      authmock.provider = 'test'
      authmock.credentials = {
        token: token,
        expires_at: 1.year.from_now
      }
      user = User.from_omniauth(authmock)
      expect(user).to be_a(User)
      expect(User.count).to eq(count + 1)
    end
  end
end
