class AddColumnToLocationDamages < ActiveRecord::Migration
  def change
    add_column :location_damages, :asset_id, :integer
  end
end
