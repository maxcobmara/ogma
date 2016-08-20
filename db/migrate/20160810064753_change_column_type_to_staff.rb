class ChangeColumnTypeToStaff < ActiveRecord::Migration
  def change
    remove_column :trainingnotes, :staff_id, :string
    add_column :trainingnotes, :staff_id, :integer
  end
end
