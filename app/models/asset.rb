class Asset < ActiveRecord::Base
  
  validates_presence_of :assignedto_id, :if => :bookable?
  
  has_many :asset_placements, :dependent => :destroy
  accepts_nested_attributes_for :asset_placements, :allow_destroy => true , :reject_if => lambda { |a| a[:location_id].blank? }
  has_many  :locations, :through => :asset_placements
  
  has_many :asset_defects
  
end

# == Schema Information
#
# Table name: assets
#
#  assetcode            :string(255)
#  assettype            :integer
#  assignedto_id        :integer
#  bookable             :boolean
#  cardno               :string(255)
#  category_id          :integer
#  country_id           :integer
#  created_at           :datetime
#  engine_no            :string(255)
#  engine_type_id       :integer
#  id                   :integer          not null, primary key
#  is_disposed          :boolean
#  is_maintainable      :boolean
#  locassigned          :boolean
#  location_id          :integer
#  manufacturer_id      :integer
#  mark_as_lost         :boolean
#  mark_disposal        :boolean
#  modelname            :string(255)
#  name                 :string(255)
#  nationcode           :string(255)
#  orderno              :string(255)
#  otherinfo            :text
#  purchasedate         :date
#  purchaseprice        :decimal(, )
#  quantity             :integer
#  quantity_type        :string(255)
#  receiveddate         :date
#  receiver_id          :integer
#  registration         :string(255)
#  serialno             :string(255)
#  status               :integer
#  subcategory          :string(255)
#  supplier_id          :integer
#  typename             :string(255)
#  updated_at           :datetime
#  warranty_length      :integer
#  warranty_length_type :integer
#
