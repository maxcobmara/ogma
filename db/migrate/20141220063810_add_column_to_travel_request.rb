class AddColumnToTravelRequest < ActiveRecord::Migration
  def change
    add_column :travel_requests, :others_car_notes, :string
  end
end
