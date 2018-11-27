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
    it { should validate_presence_of(:repository_id) }
    it { should validate_presence_of(:url) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:source_created_at) }
    it { should validate_presence_of(:source_updated_at) }
  end

  describe 'associations' do
    it { should have_and_belong_to_many(:github_users) }
    it { should belong_to(:repository) }
    it { should belong_to(:organization) }
  end

  describe '#assignees' do
    it 'tracks the GithubUsers that are assigned to a given Statistic' do
      jack = create :github_user
      jane = create :github_user
      stat = create :statistic, assignees: [jack.github_id, jane.github_id]

      expect(stat.assignees).to match_array [jack.github_id, jane.github_id]
    end
  end
end
