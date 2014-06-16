class Stationery < ActiveRecord::Base
  
  
  
  validates :category, presence: true, uniqueness: true
  validates_uniqueness_of :code
  
  has_many :addsuppliers, :foreign_key => 'supplier_id' , :dependent => :destroy
  accepts_nested_attributes_for :addsuppliers, :allow_destroy => true
  
  has_many :usesupplies, :foreign_key => 'supplier_id', :dependent => :destroy
  accepts_nested_attributes_for :usesupplies, :allow_destroy => true
  
  
  def current_quantity
    a = Addsupplier.where(supplier_id: id).sum(:quantity)
    b = Usesupply.where(supplier_id: id).sum(:quantity)
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
