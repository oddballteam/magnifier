# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      org = create :organization

      expect(org).to be_valid
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
  end
end
