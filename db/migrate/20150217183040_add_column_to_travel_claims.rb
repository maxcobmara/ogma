class AddColumnToTravelClaims < ActiveRecord::Migration
  def change
    add_column :travel_claims, :accommodations, :text
  end
end
