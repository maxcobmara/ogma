class AddTravelRequestCodeToTravelRequest < ActiveRecord::Migration
  def self.up
    add_column :travel_requests, :code, :string
  end

  def self.down
     remove_column :travel_requests, :code
  end
end
