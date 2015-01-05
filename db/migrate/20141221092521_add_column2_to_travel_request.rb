class AddColumn2ToTravelRequest < ActiveRecord::Migration
  def change
    add_column :travel_requests, :mileage_history, :integer
  end
end
