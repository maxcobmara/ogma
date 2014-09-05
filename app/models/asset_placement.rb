class AssetPlacement < ActiveRecord::Base  
  belongs_to :asset, :foreign_key => 'asset_id'
  belongs_to :location, :foreign_key => 'location_id'
  belongs_to :staff, :foreign_key => 'staff_id'
  
  fixed=Asset.hm.pluck(:id)
  inventory=Asset.inv.pluck(:id)
  
  scope :p_fixed, -> {where('asset_id IN(?)',fixed)}
  scope :p_inventory, -> {where('asset_id IN(?)', inventory)}
  
end

# == Schema Information
#
# Table name: asset_placements
#
#  asset_id    :integer
#  created_at  :datetime
#  id          :integer          not null, primary key
#  location_id :integer
#  quantity    :integer
#  reg_on      :date
#  staff_id    :integer
#  updated_at  :datetime
#
