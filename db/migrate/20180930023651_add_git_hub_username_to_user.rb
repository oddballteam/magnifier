# frozen_string_literal: true

class AddGitHubUsernameToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :git_hub_username, :string
  end
end
