# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'factory' do
    it 'has a valid factory' do
      user = create :user

      expect(user).to be_valid
    end
  end
end
