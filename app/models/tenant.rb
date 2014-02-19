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