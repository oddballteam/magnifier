class AddCreatedByToStatistics < ActiveRecord::Migration[5.2]
  def change
    add_column :statistics, :source_created_by, :integer
    add_index :statistics, :source_created_by
  end
end
