class AddColumnsToVisitors < ActiveRecord::Migration
  def change
    add_column :visitors, :college_id, :integer
    add_column :visitors, :data, :text
  end
end
