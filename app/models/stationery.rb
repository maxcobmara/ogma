class Stationery < ActiveRecord::Base
  
  validates :category, presence: true, uniqueness: true
  validates_uniqueness_of :code
  
  has_many :stationery_adds, :foreign_key => 'stationery_id' , :dependent => :destroy
  accepts_nested_attributes_for :stationery_adds, :allow_destroy => true
  
  has_many :stationery_uses, :foreign_key => 'stationery_id', :dependent => :destroy
  accepts_nested_attributes_for :stationery_uses, :allow_destroy => true
  
  
  def current_quantity
    a = StationeryAdd.where(stationery_id: id).sum(:quantity)
    b = StationeryUse.where(stationery_id: id).sum(:quantity)
    a - b
  end
end

# == Schema Information
#
# Table name: stationeries
#
#  category    :string(255)
#  code        :string(255)
#  created_at  :datetime
#  id          :integer          not null, primary key
#  maxquantity :decimal(, )
#  minquantity :decimal(, )
#  unittype    :string(255)
#  updated_at  :datetime
#
