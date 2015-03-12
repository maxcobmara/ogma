class Asset < ActiveRecord::Base
  
  validates_presence_of :assignedto_id, :if => :bookable?
  validates_presence_of     :assettype
  
  has_many :asset_placements, :dependent => :destroy
  accepts_nested_attributes_for :asset_placements, :allow_destroy => true , :reject_if => lambda { |a| a[:location_id].blank? }
  has_many  :locations, :through => :asset_placements
  
  belongs_to :suppliedby,  :class_name => 'AddressBook', :foreign_key => 'supplier_id'
  
  #belongs_to :location, :foreign_key => "location_id" --> not required - refer line 5
  #belongs_to :staff,    :class_name => 'Staff', :foreign_key => "assignedto_id"
  belongs_to :receiver, :class_name => 'Staff', :foreign_key => 'receiver_id'
  belongs_to :assignedto,   :class_name => 'Staff', :foreign_key => 'assignedto_id'
  
  belongs_to :category,     :class_name => 'Assetcategory', :foreign_key => 'category_id'
  has_many :asset_defects
  has_many :maints
  has_many :asset_loans
  has_many :asset_disposal
  has_many :asset_loss
  has_many :location_damages
  
  scope :hm, -> { where(assettype: 1)}
  scope :inv, -> {where(assettype: 2)}
  
  def code_asset
    "#{assetcode} - #{name}"
  end
  
  def code_typename_name_modelname_serialno
    "#{assetcode} - #{typename} - #{name} - #{modelname} - #{serialno} "
  end
  
  def code_typename_serial_no
    "#{assetcode} - #{typename} - #{serialno} "
  end
  
  def name_modelname
    "#{name} - #{modelname} "
  end
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
