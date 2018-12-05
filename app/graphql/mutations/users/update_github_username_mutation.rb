module Mutations
  module Users
    class UpdateGithubUsernameMutation < Mutations::BaseMutation
      description "Update a user's github username"
      null true
      argument :githubUsername, String, required: false
      field :errors, [String], null: true
      def resolve(github_username:)
        puts github_username
        current_user = context[:current_user]
        current_user.github_username = github_username
        current_user.errors unless current_user.save!
      end
    end
  end
end
