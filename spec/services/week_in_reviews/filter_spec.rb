# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeekInReviews::Filter do
  let(:start_time) { '2018-10-08T00:00:00Z' }
  let(:end_time) { '2018-10-14T23:59:59Z' }
  let(:github_user) { create :github_user }
  let(:hub_id) { github_user.github_id }
  let(:non_user) { create :github_user }
  let(:filter) { WeekInReviews::Filter.new(hub_id, start_time, end_time) }

  before do
    create :statistic, :open_pr, source_created_by: hub_id
    create :statistic, :closed_pr, source_created_by: hub_id
    create :statistic, :merged_pr, source_created_by: hub_id
    create :statistic, :open_issue, source_created_by: hub_id
    create :statistic, :closed_issue, source_created_by: hub_id
    create :statistic, :open_issue, assignees: [hub_id]
    create :statistic, :closed_issue, assignees: [hub_id]
    create :statistic, source_created_by: non_user.github_id
    create :statistic, assignees: [non_user.github_id]
  end

  describe '.initialize' do
    it 'raises an error if an invalid time format is passed' do
      invalid_time = Time.now

      expect { WeekInReviews::Filter.new(hub_id, invalid_time, end_time) }.to raise_error(
        WeekInReviews::Error,
        'Time must be a string'
      )
    end
  end

  describe '#created_issues' do
    let(:statistics) { filter.created_issues }

    it 'finds and returns the expected number of Statistics' do
      expect(statistics.count).to eq 2
    end

    it 'only returns issues' do
      expect(statistics.pluck(:source_type).uniq).to eq [Statistic::ISSUE]
    end

    it 'returns both open and closed issues' do
      expect(statistics.pluck(:state)).to include Statistic::OPEN, Statistic::CLOSED
    end

    it 'only returns Statistics created by the passed github_user_id' do
      expect(statistics.pluck(:source_created_by).uniq).to eq [hub_id]
    end

    it 'only returns Statistics created after the passed start_time' do
      statistics.pluck(:source_created_at).each do |created_at|
        expect(created_at).to be >= start_time
      end
    end

    it 'only returns Statistics created before the passed end_time' do
      statistics.pluck(:source_created_at).each do |created_at|
        expect(created_at).to be <= end_time
      end
    end
  end

  describe '#worked_issues' do
    let(:statistics) { filter.worked_issues }

    it 'finds and returns the expected number of Statistics' do
      expect(statistics.count).to eq 2
    end

    it 'only returns issues' do
      expect(statistics.pluck(:source_type).uniq).to eq [Statistic::ISSUE]
    end

    it 'returns both open and closed issues' do
      expect(statistics.pluck(:state)).to include Statistic::OPEN, Statistic::CLOSED
    end

    it 'only returns Statistics assigned to the passed github_user_id' do
      statistics.pluck(:assignees).each do |assignees|
        expect(assignees).to include hub_id
      end
    end

    it 'only returns Statistics updated after the passed start_time' do
      statistics.pluck(:source_updated_at).each do |updated_at|
        expect(updated_at).to be >= start_time
      end
    end

    it 'only returns Statistics updated before the passed end_time' do
      statistics.pluck(:source_updated_at).each do |updated_at|
        expect(updated_at).to be <= end_time
      end
    end
  end

  describe '#closed_issues' do
    let(:statistics) { filter.closed_issues }

    it 'finds and returns the expected number of Statistics' do
      expect(statistics.count).to eq 1
    end

    it 'only returns issues' do
      expect(statistics.pluck(:source_type).uniq).to eq [Statistic::ISSUE]
    end

    it 'only returns closed issues' do
      expect(statistics.pluck(:state).uniq).to eq [Statistic::CLOSED]
    end

    it 'only returns Statistics assigned to the passed github_user_id' do
      statistics.pluck(:assignees).each do |assignees|
        expect(assignees).to include hub_id
      end
    end

    it 'only returns Statistics closed after the passed start_time' do
      statistics.pluck(:source_closed_at).each do |closed_at|
        expect(closed_at).to be >= start_time
      end
    end

    it 'only returns Statistics closed before the passed end_time' do
      statistics.pluck(:source_closed_at).each do |closed_at|
        expect(closed_at).to be <= end_time
      end
    end
  end

  describe '#created_pull_requests' do
    let(:statistics) { filter.created_pull_requests }

    it 'finds and returns the expected number of Statistics' do
      expect(statistics.count).to eq 3
    end

    it 'only returns pull requests' do
      expect(statistics.pluck(:source_type).uniq).to eq [Statistic::PR]
    end

    it 'returns open, closed and merged pull requests' do
      expect(statistics.pluck(:state)).to include Statistic::OPEN, Statistic::CLOSED, Statistic::MERGED
    end

    it 'only returns Statistics created by the passed github_user_id' do
      expect(statistics.pluck(:source_created_by).uniq).to eq [hub_id]
    end

    it 'only returns Statistics created after the passed start_time' do
      statistics.pluck(:source_created_at).each do |created_at|
        expect(created_at).to be >= start_time
      end
    end

    it 'only returns Statistics created before the passed end_time' do
      statistics.pluck(:source_created_at).each do |created_at|
        expect(created_at).to be <= end_time
      end
    end
  end

  describe '#worked_pull_requests' do
    let(:statistics) { filter.worked_pull_requests }

    it 'finds and returns the expected number of Statistics' do
      expect(statistics.count).to eq 3
    end

    it 'only returns pull requests' do
      expect(statistics.pluck(:source_type).uniq).to eq [Statistic::PR]
    end

    it 'returns open, closed and merged pull requests' do
      expect(statistics.pluck(:state)).to include Statistic::OPEN, Statistic::CLOSED, Statistic::MERGED
    end

    it 'only returns Statistics created by the passed github_user_id' do
      expect(statistics.pluck(:source_created_by).uniq).to eq [hub_id]
    end

    it 'only returns Statistics updated after the passed start_time' do
      statistics.pluck(:source_updated_at).each do |updated_at|
        expect(updated_at).to be >= start_time
      end
    end

    it 'only returns Statistics updated before the passed end_time' do
      statistics.pluck(:source_updated_at).each do |updated_at|
        expect(updated_at).to be <= end_time
      end
    end
  end

  describe '#merged_pull_requests' do
    let(:statistics) { filter.merged_pull_requests }

    it 'finds and returns the expected number of Statistics' do
      expect(statistics.count).to eq 1
    end

    it 'only returns pull requests' do
      expect(statistics.pluck(:source_type).uniq).to eq [Statistic::PR]
    end

    it 'only returns merged pull requests' do
      expect(statistics.pluck(:state).uniq).to eq [Statistic::MERGED]
    end

    it 'only returns Statistics created by the passed github_user_id' do
      expect(statistics.pluck(:source_created_by).uniq).to eq [hub_id]
    end

    it 'only returns Statistics closed after the passed start_time' do
      statistics.pluck(:source_closed_at).each do |closed_at|
        expect(closed_at).to be >= start_time
      end
    end

    it 'only returns Statistics closed before the passed end_time' do
      statistics.pluck(:source_closed_at).each do |closed_at|
        expect(closed_at).to be <= end_time
      end
    end
  end
end
