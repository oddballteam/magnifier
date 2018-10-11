# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubUser, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      github_user = create :github_user

      expect(github_user).to be_valid
    end

    it { should validate_presence_of(:github_login) }
    it { should validate_presence_of(:github_id) }
    it { should validate_presence_of(:html_url) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:statistics) }
  end
end
