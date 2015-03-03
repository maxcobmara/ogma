class StationeryAdd < ActiveRecord::Base
  belongs_to :stationery
  
  validates_presence_of :document, :unitcost, :received, :quantity #, :lpono
  validates_format_of      :quantity, :with => /[1-9]/, :message => I18n.t('activerecord.errors.messages.invalid')
  validates_format_of      :unitcost, :with => /[1-9]/, :message => I18n.t('activerecord.errors.messages.invalid')
  
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
