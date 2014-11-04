class Vehicle < ActiveRecord::Base
  
  belongs_to :staffvehicle, :class => 'Staff', :foreign_key => 'staff_id'
  
  validates_presence_of :reg_no, :cylinder_capacity
  
end 