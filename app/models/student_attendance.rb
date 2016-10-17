class StudentAttendance < ActiveRecord::Base
  
  before_save :set_absent_details_nil_if_attend
  belongs_to :weeklytimetable_detail, :foreign_key => 'weeklytimetable_details_id'
  belongs_to :student
  belongs_to :college
  
  validates_uniqueness_of :student_id, :scope => :weeklytimetable_details_id, :message => " - Attendance for this student for selected schedule/class already exist" 
  
  validates_presence_of :reason, :if => :is_absent?
  
  attr_accessor :lecturer_id
   
  # define scope
  def self.student_search(query) 
    student_ids=Student.where('name ILIKE (?) or matrixno ILIKE (?)', "%#{query}%", "%#{query}%").pluck(:id)
    where('student_id IN(?)', student_ids)
  end

  def self.intake_search(query)
    intake = query.split(",")[0]
    programme = query.split(",")[1].to_i
    return joins(:student).where('course_id=? and intake>=? and intake<?',"#{programme}", "#{intake}","#{intake.to_date+1.day}")
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:student_search, :intake_search]
  end
  
  def set_absent_details_nil_if_attend
    if attend==true
      self.reason = ""
      self.action = ""
      self.status = ""
      self.remark = ""
    end
  end
  
  #single record
  def is_absent?
    if attend==false 
      if reason=="" || reason==nil 
        return true
      end
    end
  end
  
  def subject_day_time
    "#{WeeklytimetableDetail.find(weeklytimetable_details_id)}"
  end
 
  def self.search2(curr_user)
    exist_wtd_ids = WeeklytimetableDetail.where(lecturer_id: curr_user.userable_id).pluck(:id)
    where('weeklytimetable_details_id IN(?)',exist_wtd_ids)
  end
  
end