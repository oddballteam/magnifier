# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeekInReviews::Boundries do
  let(:date) { '2018-10-11' }
  let(:boundries) { WeekInReviews::Boundries.new(date) }

  describe '#initialize' do
    it 'raises an error if an invalid date format is passed' do
      invalid_date = Date.today

      expect { WeekInReviews::Boundries.new(invalid_date) }.to raise_error(
        WeekInReviews::Error,
        'Date must be a string'
      )
    end
  end

  describe '#start_date' do
    it 'sets the start_date to the Monday of the passed week', :aggregate_failures do
      expect(boundries.start_date.monday?).to eq true
      expect(boundries.start_date.to_s).to eq '2018-10-08'
    end
  end

  describe '#end_date' do
    it 'sets the end_date to the Sunday of the passed week', :aggregate_failures do
      expect(boundries.end_date.sunday?).to eq true
      expect(boundries.end_date.to_s).to eq '2018-10-14'
    end
  end

  describe '#start_time' do
    it 'sets the start_time to the beginning of Monday of the passed week' do
      expect(boundries.start_time).to eq '2018-10-08T00:00:00Z'
    end

    it 'is an iso8601 string', :aggregate_failures do
      expect(boundries.start_time.class).to eq String
      expect(boundries.start_time).to include 'T00:00:00Z'
    end
  end

  describe '#end_time' do
    it 'sets the end_time to the end of Sunday of the passed week' do
      expect(boundries.end_time).to eq '2018-10-14T23:59:59Z'
    end

    it 'is an iso8601 string', :aggregate_failures do
      expect(boundries.end_time.class).to eq String
      expect(boundries.end_time).to include 'T23:59:59Z'
    end
  end
end
