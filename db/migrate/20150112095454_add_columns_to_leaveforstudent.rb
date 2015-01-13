class AddColumnsToLeaveforstudent < ActiveRecord::Migration
  def change
    add_column :leaveforstudents, :approved2, :boolean
    add_column :leaveforstudents, :staff_id2, :integer
    add_column :leaveforstudents, :approvedate2, :date
  end
end
