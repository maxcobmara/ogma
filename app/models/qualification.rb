class Qualification < ActiveRecord::Base
  belongs_to :staff
  belongs_to :student
  
  def level_name
    (DropDown::QUALIFICATION_LEVEL.find_all{|disp, value| value == level_id.to_i}).map {|disp, value| disp}[0]+": "+institute
  end
end

# == Schema Information
#
# Table name: qualifications
#
#  created_at   :datetime
#  id           :integer          not null, primary key
#  institute    :string(255)
#  institute_id :integer
#  level_id     :integer
#  qname        :string(255)
#  staff_id     :integer
#  student_id   :integer
#  updated_at   :datetime
#
