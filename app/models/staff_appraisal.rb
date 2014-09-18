class StaffAppraisal < ActiveRecord::Base
  
 belongs_to :appraised,      :class_name => 'Staff', :foreign_key => 'staff_id'
 
 
end