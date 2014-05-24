class Intake < ActiveRecord::Base
  belongs_to :programme, :foreign_key => 'programme_id'
  has_many   :students
  has_many   :weeklytimetables  #20March2013
  has_many   :lessonplans, :class_name => 'LessonPlan', :foreign_key=>'intake_id' 
end

# == Schema Information
#
# Table name: intakes
#
#  created_at       :datetime
#  description      :string(255)
#  id               :integer          not null, primary key
#  is_active        :boolean
#  monthyear_intake :date
#  name             :string(255)
#  programme_id     :integer
#  register_on      :date
#  updated_at       :datetime
#
