# frozen_string_literal: true

class AddGitHubUsernameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :github_username, :string
  end
end
