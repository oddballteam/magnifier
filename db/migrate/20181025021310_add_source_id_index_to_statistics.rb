class AddSourceIdIndexToStatistics < ActiveRecord::Migration[5.2]
  def change
    add_index :statistics, :source_id
  end
end
