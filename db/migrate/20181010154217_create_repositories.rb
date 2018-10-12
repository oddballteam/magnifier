class CreateRepositories < ActiveRecord::Migration[5.1]
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :url
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
