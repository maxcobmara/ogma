class StudentAttendance < ActiveRecord::Base
  belongs_to :weeklytimetable_detail, :foreign_key => 'weeklytimetable_details_id'
  belongs_to :student
  #validates_uniqueness_of :student_id, :scope => :weeklytimetable_details_id, :message => " - Attendance for this student was already created for selected schedule/class"
  
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
  
  def subject_day_time
    "#{WeeklytimetableDetail.find(weeklytimetable_details_id)}"
  end
  
  #2June2013
  def self.search2(search)
      if search
          if search == '0'
              @student_attendances = StudentAttendance.all
          else
              @student_attendances = StudentAttendance.find(:all, :conditions=>['weeklytimetable_details_id=?',search])
          end
      else
          @student_attendances = StudentAttendance.all
      end
  end
  
  #11July2013
  def self.search44444(search,programme)
      if search
          if search == '0'
              @student_attendances = StudentAttendance.all
          else
              #@student_attendances = []
             # @student_attendances_intake = StudentAttendance.all.group_by{|x|x.student.intake.strftime("%Y-%m-%d")}
              #@student_attendances_intake.each do |intake,sa|
                  #if intake.to_s == search.to_s#  "2011-01-01"
                   # @studentattendance_ids = sa.map(&:id)#[4781,4782,4783,4784,4785,4786]
                    #@student_attendances = StudentAttendance.find(:all,:conditions=>['id IN (?)',@studentattendance_ids])
                    #@student_attendances = StudentAttendance.all
                    
                  #end
              #end
              #@student_attendances = StudentAttendance.all
              #@student_attendances = StudentAttendance.find(:all, :joins=>:student, :conditions => ['intake>=? and intake<?',"2011-01-01","2011-01-02"])
              @student_attendances = StudentAttendance.find(:all, :joins=>:student, :conditions => ['course_id=? and intake>=? and intake<?',programme, search,search.to_date+1.day])
              
              #@student_attendances = StudentAttendance.find(:all, :conditions=>['weeklytimetable_details_id=?',search])
          end
      else
        unless programme.nil?
          @student_attendances = StudentAttendance.find(:all, :joins=>:student, :conditions => ['course_id=?',programme])
        else  #if admin
          @student_attendances = StudentAttendance.all
        end
      end
  end
  
  
end
 
