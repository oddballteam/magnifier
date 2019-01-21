# frozen_string_literal: true

require 'rails_helper'
require_relative '../../../support/github_setup'

RSpec.describe Mutations::Accomplishments::AccomplishmentsCreateForStatisticMutation do
  setup_github_org_and_user

  let!(:github_user) { create(:github_user, user_id: user.id, github_login: user.github_username) }
  let(:week_in_review) { create :week_in_review, user: user, start_date: '2018-12-24', end_date: '2018-12-30' }
  let(:owner) { 'oddballio' }
  let(:github_url) { "https://github.com/#{owner}/magnifier/pull/91" }
  let(:mutation) do
    <<-GRAPHQL
      mutation {
        accomplishmentsCreateForStatistic(
          githubUrl: "#{github_url}",
          weekInReviewId: #{week_in_review.id}
        ) {
          accomplishments {
            id
            type
            action
            weekInReview {
              id
            }
            statistic {
              id
            }
          }
          statistic {
            id
          }
          errors {
            type
            message
          }
        }
      }
    GRAPHQL
  end

  it 'returns the newly created Accomplishments' do
    VCR.use_cassette 'github/pull_request/merged' do
      response = MagnifierSchema.execute(mutation, context: { current_user: user })
      accomplishments = response.dig 'data', 'accomplishmentsCreateForStatistic', 'accomplishments'

      expect(accomplishments).to be_present
    end
  end

  it 'returns the newly associated/created Statistic' do
    VCR.use_cassette 'github/pull_request/merged' do
      response  = MagnifierSchema.execute(mutation, context: { current_user: user })
      statistic = response.dig 'data', 'accomplishmentsCreateForStatistic', 'statistic'

      expect(statistic).to be_present
    end
  end

  it 'returns no errors' do
    VCR.use_cassette 'github/pull_request/merged' do
      response = MagnifierSchema.execute(mutation, context: { current_user: user })
      errors   = response.dig 'data', 'accomplishmentsCreateForStatistic', 'errors'

      expect(errors).to_not be_present
    end
  end

  context 'when the passed github_url Statistic is not present in the db' do
    it 'creates the new Statistic record' do
      VCR.use_cassette 'github/pull_request/merged' do
        expect do
          MagnifierSchema.execute(mutation, context: { current_user: user })
        end.to change { Statistic.count }.from(0).to(1)
      end
    end
  end

  context 'when the passed github_url Statistic is present in the db' do
    let!(:statistic) do
      create(
        :statistic,
        :merged_pr,
        url: github_url,
        source_created_at: '2018-12-24T20:10:35Z',
        source_updated_at: '2018-12-25T20:10:35Z',
        source_closed_at: '2018-12-26T20:10:35Z'
      )
    end

    it 'it returns the existing Statistic record' do
      response = MagnifierSchema.execute(mutation, context: { current_user: user })
      returned_statistic = response.dig 'data', 'accomplishmentsCreateForStatistic', 'statistic'

      expect(returned_statistic['id']).to eq statistic.id
    end

    it 'does not create a duplicate Statistic record' do
      expect do
        MagnifierSchema.execute(mutation, context: { current_user: user })
      end.to_not(change { Statistic.count })
    end
  end

  context 'when a WeekInReviews::Error is raised' do
    let(:week_in_review) { create :week_in_review, user: user }
    let(:invalid_mutation) do
      <<-GRAPHQL
        mutation {
          accomplishmentsCreateForStatistic(
            githubUrl: "#{github_url}",
            weekInReviewId: #{week_in_review.id}
          ) {
            accomplishments {
              id
            }
            statistic {
              id
            }
            errors {
              type
              message
            }
          }
        }
      GRAPHQL
    end

    it 'it returns details on the errors and does not blow up' do
      VCR.use_cassette 'github/pull_request/merged' do
        response = MagnifierSchema.execute(invalid_mutation, context: { current_user: user })
        errors   = response.dig 'data', 'accomplishmentsCreateForStatistic', 'errors'

        expect(errors).to be_present
      end
    end
  end

  context 'when a Github::ServiceError is raised' do
    let(:bad_url) { 'https://github.com/department-of-veterans-affairs/vets-api/pull/2682555' }
    let(:invalid_mutation) do
      <<-GRAPHQL
        mutation {
          accomplishmentsCreateForStatistic(
            githubUrl: "#{bad_url}",
            weekInReviewId: #{week_in_review.id}
          ) {
            accomplishments {
              id
            }
            statistic {
              id
            }
            errors {
              type
              message
            }
          }
        }
      GRAPHQL
    end

    it 'it returns details on the errors and does not blow up' do
      VCR.use_cassette 'github/pull_request/not_found' do
        response = MagnifierSchema.execute(invalid_mutation, context: { current_user: user })
        errors   = response.dig 'data', 'accomplishmentsCreateForStatistic', 'errors'

        expect(errors).to be_present
      end
    end
  end
end
