class Evactivity < ActiveRecord::Base
  belongs_to :staff_appraisal, :foreign_key => 'appraisal_id'
  #validates_presence_of :evactivity
 
 def self.find_main
    Staff.find(:all, :condition => ['staff_id IS NULL'])
 end
  
end

# == Schema Information
#
# Table name: evactivities
#
#  actdt        :date
#  actlevel     :string(255)
#  appraisal_id :integer
#  created_at   :datetime
#  evactivity   :string(255)
#  evaldt       :date
#  id           :integer          not null, primary key
#  updated_at   :datetime
#
