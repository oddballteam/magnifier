# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Statistic, type: :model do
  describe 'validations' do
    it 'has a valid factory' do
      stat = create :statistic

      expect(stat).to be_valid
    end

    it { should validate_presence_of(:source_id) }
    it { should validate_presence_of(:source_type) }
    it { should validate_presence_of(:source) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:organization_id) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:source_created_at) }
    it { should validate_presence_of(:source_updated_at) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:github_users) }
  end
end
