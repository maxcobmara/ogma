class AssetPlacement < ActiveRecord::Base
  belongs_to :asset
  belongs_to :location
  belongs_to :staff
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
