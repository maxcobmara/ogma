class StationeryAdd < ActiveRecord::Base
  belongs_to :stationery
  
  attr_accessor :total
  
  def line_item_value
    quantity * unitcost
  end
  
  def total
    
  end
  
  def boo
    "ba"
  end
end

# == Schema Information
#
# Table name: addsuppliers
#
#  created_at  :datetime
#  document    :string(255)
#  id          :integer          not null, primary key
#  lpono       :string(255)
#  quantity    :decimal(, )
#  received    :date
#  supplier_id :integer
#  unitcost    :decimal(, )
#  updated_at  :datetime
#
