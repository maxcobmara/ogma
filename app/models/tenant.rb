class Tenant < ActiveRecord::Base
  belongs_to :location
  belongs_to :staff
  belongs_to :student
  
  
  #student autocomplete
  def student_name
    student.try(:name)
  end

  def student_name=(name)
    self.student = Student.find_or_create_by_name(name) if name.present?
  end
end

# == Schema Information
#
# Table name: tenants
#
#  created_at        :datetime
#  force_vacate      :boolean
#  id                :integer          not null, primary key
#  keyaccept         :date
#  keyexpectedreturn :date
#  keyreturned       :date
#  location_id       :integer
#  staff_id          :integer
#  student_id        :integer
#  updated_at        :datetime
#
