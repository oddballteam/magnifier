# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Accomplishment, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      accomplishment = create :accomplishment

      expect(accomplishment).to be_valid
    end

    it { should validate_presence_of(:week_in_review_id) }
    it { should validate_presence_of(:statistic_id) }
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:action) }
  end

  describe 'associations' do
    it { should belong_to(:week_in_review) }
    it { should belong_to(:statistic) }
    it { should belong_to(:user) }
  end
end
