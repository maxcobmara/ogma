class LessonplanMethodology < ActiveRecord::Base
  belongs_to :lesson_plan,     :foreign_key => 'lesson_plan_id'
end

# == Schema Information
#
# Table name: lessonplan_methodologies
#
#  content           :text
#  created_at        :datetime
#  end_meth          :time
#  evaluation        :text
#  id                :integer          not null, primary key
#  lecturer_activity :text
#  lesson_plan_id    :integer
#  start_meth        :time
#  student_activity  :text
#  training_aids     :text
#  updated_at        :datetime
#
