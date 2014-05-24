class Addsupplier < ActiveRecord::Base
  belongs_to :stationery
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
