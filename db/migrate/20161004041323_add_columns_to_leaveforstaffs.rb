class AddColumnsToLeaveforstaffs < ActiveRecord::Migration
  def change
    add_column :leaveforstaffs, :address_on_leave, :string
    add_column :leaveforstaffs, :phone_on_leave, :integer
    add_column :leaveforstaffs, :requestdate, :date
  end
end
