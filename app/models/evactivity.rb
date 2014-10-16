class Evactivity < ActiveRecord::Base
  belongs_to :staff_appraisal, :foreign_key => 'appraisal_id'
  #validates_presence_of :evactivity
 
 def self.find_main
    Staff.find(:all, :condition => ['staff_id IS NULL'])
 end
  
end
 
