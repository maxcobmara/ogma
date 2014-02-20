class Asset < ActiveRecord::Base
  has_many :asset_placements, :dependent => :destroy
  accepts_nested_attributes_for :asset_placements, :allow_destroy => true , :reject_if => lambda { |a| a[:location_id].blank? }
  has_many  :locations, :through => :asset_placements
end
  
  