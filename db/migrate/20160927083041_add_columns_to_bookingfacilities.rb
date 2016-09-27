class AddColumnsToBookingfacilities < ActiveRecord::Migration
  def change
    add_column :bookingfacilities, :total_participant, :integer
    add_column :bookingfacilities, :purpose, :string
  end
end
