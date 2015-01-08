class StationeryUse < ActiveRecord::Base
 belongs_to :stationery
 belongs_to :issuesupply,       :class_name => 'Staff', :foreign_key => 'issuedby'
 belongs_to :receivesupply,       :class_name => 'Staff', :foreign_key => 'receivedby'
end

# == Schema Information
#
# Table name: usesupplies
#
#  created_at  :datetime
#  id          :integer          not null, primary key
#  issuedate   :date
#  issuedby    :integer
#  quantity    :decimal(, )
#  receivedby  :integer
#  supplier_id :integer
#  updated_at  :datetime
#
