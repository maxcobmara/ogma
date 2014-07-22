class Timetable < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  belongs_to :creator, :class_name => 'Staff', :foreign_key => 'created_by'
  
  has_many :timetable_periods, :dependent => :destroy
  accepts_nested_attributes_for :timetable_periods, :allow_destroy => true#, :reject_if => lambda { |a| a[:start_at].blank? }

  #20March2013- weeklytimetables - newly added models..
  has_many :timetable_for_monthurs,   :class_name => 'WeeklyTimetable'#, :foreign_key => 'format1'#, :dependent => :nullify
  has_many :timetable_for_friday,     :class_name => 'WeeklyTimetable'#, :foreign_key => 'format2'#, :dependent => :nullify

end

# == Schema Information
#
# Table name: timetables
#
#  code        :string(255)
#  created_at  :datetime
#  created_by  :integer
#  description :string(255)
#  id          :integer          not null, primary key
#  name        :string(255)
#  updated_at  :datetime
#
