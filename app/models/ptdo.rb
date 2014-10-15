class Ptdo < ActiveRecord::Base
  belongs_to  :ptschedule
  belongs_to  :staff
end

# == Schema Information
#
# Table name: ptdos
#
#  created_at     :datetime
#  dept_approve   :boolean
#  dept_review    :string(255)
#  final_approve  :boolean
#  id             :integer          not null, primary key
#  justification  :string(255)
#  ptcourse_id    :integer
#  ptschedule_id  :integer
#  replacement_id :integer
#  staff_id       :integer
#  trainee_report :text
#  unit_approve   :boolean
#  unit_review    :string(255)
#  updated_at     :datetime
#
