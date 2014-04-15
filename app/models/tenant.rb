class Tenant < ActiveRecord::Base
  before_save :save_my_vars
  belongs_to :location, touch: true
  belongs_to :staff
  belongs_to :student
  
  
  #student autocomplete
  def student_icno
    student.try(:icno)
  end

  def student_icno=(icno)
    self.student = Student.find_or_create_by_icno(icno) if icno.present?
  end
  
  def save_my_vars
    if id.nil? || id.blank?
      self.force_vacate = 0
    end
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
