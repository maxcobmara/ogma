class AddColumnToRank < ActiveRecord::Migration
  def change
    add_column :ranks, :employgrade_id, :integer
    add_column :ranks, :shortname, :string
  end
end
