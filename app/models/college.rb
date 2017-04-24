class College < ActiveRecord::Base
  
  before_destroy :valid_for_removal
  has_many :users
  has_many :pages
  has_many :examanalyses
  has_many :exams
  has_many :leaveforstaffs
  has_many :timetables
  has_many :timetable_periods
  has_many :weeklytimetables
  has_many :weeklytimetable_details
  has_many :intakes
  has_many :lesson_plans
  has_many :lessonplan_methodologies
  has_many :students
  has_many :tenants
  has_many :cofiles
  has_many :student
  has_many :student_discipline_cases
  has_many :student_counseling_sessions
  has_many :student_attendances
  has_many :leaveforstudents
  has_many :documents
  has_many :circulations
  has_many :examquestions
  has_many :exammarks
  has_many :grades
  has_many :ptbudgets
  has_many :ptcourses
  has_many :ptschedules
  has_many :ptdos
  has_many :topicdetails
  has_many :travel_requests
  has_many :travel_claims
  has_many :staffs
  has_many :positions
  has_many :postinfos
  has_many :instructor_appraisals
  has_many :average_instructors
  has_many :evaluate_courses
  has_many :average_courses
  has_many :banks
  has_many :insurance_companies
  has_many :librarytransactions
  has_many :books
  has_many :visitors
  has_many :staffsearch2s
  has_many :staff_attendances
  has_many :staffattendancesearches
  has_many :ptdosearches
  has_many :booksearches
  has_many :librarytransactionsearches
  has_many :repositorysearches
  # staffs
  
  serialize :data, Hash
  
  def address=(value)
    data[:address]=value
  end
  
  def address
    data[:address]
  end
  
  def phone=(value)
    data[:phone]=value
  end
  
  def phone
    data[:phone]
  end
  
  def fax=(value)
    data[:fax]=value
  end
  
  def fax
    data[:fax]
  end
  
  def email=(value)
    data[:email]=value
  end
    
  def email
    data[:email]
  end
  
  def logo=(value)
    data[:logo]=value
  end
  
  def logo
    data[:logo]
  end  
  
  def library_email=(value)
    data[:library_email]=value
  end
  
  def library_email
    data[:library_email]
  end
  
  def library_pwd=(value)
    data[:library_pwd]=value
  end
  
  def library_pwd
    data[:library_pwd]
  end

  def valid_for_removal
    if users.count ==0
      return true
    else
      return false
    end
  end
  
end