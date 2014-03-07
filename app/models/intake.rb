class Intake < ActiveRecord::Base
  belongs_to :programme, :foreign_key => 'programme_id'
  has_many   :students
  has_many   :weeklytimetables  #20March2013
  has_many   :lessonplans, :class_name => 'LessonPlan', :foreign_key=>'intake_id' 
end