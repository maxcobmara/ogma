class LessonPlanTrainingnote < ActiveRecord::Base
  belongs_to :lesson_plan
  belongs_to :trainingnote
end

# == Schema Information
#
# Table name: lesson_plan_trainingnotes
#
#  created_at      :datetime
#  id              :integer          not null, primary key
#  lesson_plan_id  :integer
#  trainingnote_id :integer
#  updated_at      :datetime
#
