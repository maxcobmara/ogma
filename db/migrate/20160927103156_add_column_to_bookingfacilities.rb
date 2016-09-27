class AddColumnToBookingfacilities < ActiveRecord::Migration
  def change
    add_column :bookingfacilities, :approver_id2, :integer
  end
end
