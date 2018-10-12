# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/MethodLength

class CreateGithubUserAndStatisticTables < ActiveRecord::Migration[5.1]
  def change
    create_table :github_users do |t|
      t.integer :user_id
      t.string :github_login
      t.string :avatar_url
      t.string :api_url
      t.string :html_url
      t.integer :github_id
      t.boolean :oddball_employee, null: false, default: false

      t.timestamps
    end

    create_table :statistics do |t|
      t.string :source_id
      t.string :source_type
      t.string :source
      t.string :state
      t.integer :repository_id
      t.references :organization, foreign_key: true
      t.string :url
      t.string :title
      t.string :source_created_at
      t.string :source_updated_at
      t.string :source_closed_at

      t.timestamps
    end

    create_table :github_users_statistics, id: false do |t|
      t.belongs_to :github_user, index: true
      t.belongs_to :statistic, index: true
    end
  end
end

# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength
