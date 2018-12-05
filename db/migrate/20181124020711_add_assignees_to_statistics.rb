class AddAssigneesToStatistics < ActiveRecord::Migration[5.2]
  # @see https://edgeguides.rubyonrails.org/active_record_postgresql.html#array
  #
  def change
    add_column :statistics, :assignees, :integer, array: true, default: []
    add_index  :statistics, :assignees, using: 'gin'
  end
end
