# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::UpdateUserDetailsMutation do
  let(:user) { create :user }
  let(:organization) { create :organization }
  it 'updates a user\'s github org' do
    mutation = <<-GRAPHQL
			mutation {
				updateUser(
					organizationId: #{organization.id}
					) {
						errors
					}
				}
    GRAPHQL
    MagnifierSchema.execute(mutation, context: { current_user: user })
    expect(user.organization_id).to eq(organization.id)
  end
  it "updates a user's github username" do
    githubUsername = 'test'
    mutation = <<~GRAPHQL
      mutation {
      	updateUser(githubUsername: "#{githubUsername}") {
      		errors
      	}
      }
    GRAPHQL

    MagnifierSchema.execute(mutation, context: { current_user: user })
    expect(user.github_username).to eq(githubUsername)
  end
  it "update's a user's PAT" do
    accessToken = '123456cafght'
    personal_access_token = 'loremipsum'
    user.update!(personal_access_token: personal_access_token)
    mutation = <<~GRAPHQL
      mutation {
      	updateUser(personalAccessToken: "#{accessToken}", githubUsername: "fart") {
      		errors
      	}
      }
    GRAPHQL
    MagnifierSchema.execute(mutation, context: { current_user: user })
    expect(user.personal_access_token).to eq(accessToken)
  end
  it 'returns nil if no current user' do
    githubUsername = 'test'
    mutation = <<~GRAPHQL
      mutation {
      	updateUser(githubUsername: "#{githubUsername}") {
      		errors
      	}
      }
    GRAPHQL
    resp = MagnifierSchema.execute(mutation, context: {}).to_h
    errors = resp['data']['updateUser']['errors']
    expect(resp['data']['updateUser']).to eql('errors' => [])
  end
  it "returns errors if it can't save" do
    same_github = 'john_doe'
    User.create(first_name: 'john', last_name: 'doe', email: 'john_doe@gmail.com', github_username: same_github)
    mutation = <<~GRAPHQL
      mutation {
      	updateUser(githubUsername: "#{same_github}") {
      		errors
      	}
      }
    GRAPHQL
    resp = MagnifierSchema.execute(mutation, context: { current_user: user }).to_h
    errors = resp['data']['updateUser']['errors']
    expect(errors).to eql(['Github username has already been taken'])
  end
end
