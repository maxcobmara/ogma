class AcademicSession < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  
   has_many :semester_for_schedule, :class_name => 'WeeklyTimetable', :foreign_key => 'semester', :dependent => :nullify
end

# == Schema Information
#
# Table name: academic_sessions
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  semester   :string(255)
#  total_week :integer
#  updated_at :datetime
#
