class AddColumsToIntakes < ActiveRecord::Migration
  def change
    add_column :intakes, :staff_id, :integer
  end
end
