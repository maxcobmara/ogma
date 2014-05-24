class Stationery < ActiveRecord::Base
  validates_presence_of :category
  validates_uniqueness_of :category, :code
  
  has_many :addsuppliers, :foreign_key => 'supplier_id' , :dependent => :destroy
  accepts_nested_attributes_for :addsuppliers, :allow_destroy => true
  
  has_many :usesupplies, :foreign_key => 'supplier_id', :dependent => :destroy
  accepts_nested_attributes_for :usesupplies, :allow_destroy => true
  
  
  def current_quantity
    a = Addsupplier.sum(:quantity, :conditions => ["supplier_id = ?", id])
    b = Usesupply.sum(:quantity, :conditions => ["supplier_id = ?", id])
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
