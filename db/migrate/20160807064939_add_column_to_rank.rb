class AddColumnToRank < ActiveRecord::Migration
  def change
    add_column :ranks, :employgrade_id, :integer
  end
end
