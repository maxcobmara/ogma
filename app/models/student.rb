class Student < ActiveRecord::Base
  
  before_save  :titleize_name

  validates_presence_of     :icno, :name, :sstatus, :stelno, :ssponsor, :gender, :sbirthdt, :mrtlstatuscd, :intake,:course_id
  validates_numericality_of :icno, :stelno
  validates_length_of       :icno, :is =>12
  validates_uniqueness_of   :icno
  
  has_attached_file :photo,
                    :url => "/assets/students/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension"
  
  
  has_and_belongs_to_many :klasses          #has_and_belongs_to_many :programmes
  belongs_to :course,         :class_name => 'Programme', :foreign_key => 'course_id'       #Link to Programme
  belongs_to :intakestudent,  :class_name => 'Intake',    :foreign_key => 'intake_id'       #Link to Model intake
  
  has_one   :user,              :dependent => :destroy                                      #Link to Model user
  has_many  :leaveforstudents,  :dependent => :destroy                                      #Link to LeaveStudent
  has_many  :student_counseling_sessions                                                    #Link to Counselling
  
  has_many  :studentgrade,    :class_name => 'Grade',     :foreign_key => 'student_id'      #Link to Model Grade
  has_many  :student,         :class_name => 'Sdicipline',:foreign_key => 'student_id'      #Link to Model Sdicipline
  has_many  :studentevaluate, :class_name => 'Courseevaluation', :foreign_key => 'student_id'#Link to Model CourseEvaluation
  has_many  :student,         :class_name => 'Residence', :foreign_key => 'student_id'      #Link to Model residence
  has_many  :tenants
  
  has_many  :librarytransactions                                                            #Link to LibraryTransactions
  #has_many :studentattendances
  has_many :student_attendances
  has_many :timetables, :through => :studentattendances
  
  has_many :exammarks                                                                       #11Apr2013-Link to Model Exammark
  
  has_many :qualifications, :dependent => :destroy
  accepts_nested_attributes_for :qualifications, :reject_if => lambda { |a| a[:level_id].blank? }
 
  has_many :kins, :dependent => :destroy
  accepts_nested_attributes_for :kins, :reject_if => lambda { |a| a[:kintype_id].blank? }
 
  has_many :spmresults, :dependent => :destroy
  accepts_nested_attributes_for :spmresults, :reject_if => lambda { |a| a[:spm_subject].blank? }
  
  #has_many :sdiciplines, :foreign_key => 'student_id'
  #has_many :std, :class_name => 'Sdicipline', :foreign_key => 'student_id'
  

  
  def self.find_main
      Programme.find(:all, :condition => ['programme_id IS NULL'])
  end
  
  def self.year_and_sem(intake)
      current_month = Date.today.strftime("%m")
		  current_year = Date.today.strftime("%Y")
		  intake_month = intake.strftime("%m")
		  intake_year = intake.strftime("%Y")
		  diff_year = current_year.to_i-intake_year.to_i
		  start_year = 1
		  start_sem = 1
		
		  if intake_month.to_i < 7 
			  if current_month.to_i < 7 
				  @year = start_year + diff_year 
				  @semester = start_sem 
			  elsif current_month.to_i > 6 
				  @year = start_year + diff_year 
				  @semester = 2 
			  end 
		  elsif intake_month.to_i > 6 
			  if current_month.to_i < 7 
				  @year = diff_year 
				  @semester = 2 							
			  elsif current_month.to_i > 6 
			    @year = start_year + diff_year 
				  @semester = 1 
			  end
		  end 
	
		  "Year #{@year}, <br> Semester #{@semester}"
  
  end
  
#----------------------Declarations---------------------------------------------------------------------------------
  def titleize_name
    self.name = name.titleize
  end
  
  def age
    Date.today.year - sbirthdt.year
  end
  
  def intake_acryn
      intake.to_date.strftime("%b %Y") 
  end 
  
  def intake_acryn_prog
      intake.to_date.strftime("%b %Y")+" | #{course.course_type} - #{course.name}"
  end
  
  #group by intake
 # def isorter
 #   suid = intake_id
 #   Intake.find(:all, :select => "name", :conditions => {:id => suid}).map(&:name)
 # end
  
  def formatted_mykad
    "#{icno[0,6]}-#{icno[6,2]}-#{icno[-4,4]}"
  end
  
  def formatted_mykad_and_student_name
    " #{formatted_mykad} #{name}" 
  end
  
  def matrix_name
    " #{matrixno} #{name}" 
  end
  
  def bil
    v=1
  end
  
  def student_name_with_programme
    "#{name} - #{programme_for_student}"
  end
  
  def programme_for_student
    if course.blank?
      "N/A"
    else
      "[#{course.course_type} - #{course.name}]"
    end
  end
  def programme_for_student2
    if course.blank?
      "N/A"
    else
      "#{course.course_type} - #{course.name}"
    end
  end
  
  def list_programme
    suid = course_id 
    Programme.find(:all, :select => "name", :conditions => {:id => suid}).map(&:name)
  end
   
   def bil
      v=1
   end
   
   def self.available_students2(subject)
       Student.find(:all, :joins=>:klasses, :conditions=> ['subject_id=?',subject])
   end
   
   
   
# ------------------------------code for repeating field qualification---------------------------------------------------

 
end

# == Schema Information
#
# Table name: students
#
#  address             :text
#  address_posbasik    :text
#  allergy             :string(255)
#  bloodtype           :string(255)
#  course_id           :integer
#  course_remarks      :string(255)
#  created_at          :datetime
#  disease             :string(255)
#  end_training        :date
#  gender              :integer
#  group_id            :integer
#  icno                :string(255)
#  id                  :integer          not null, primary key
#  intake              :date
#  intake_id           :integer
#  matrixno            :string(255)
#  medication          :string(255)
#  mrtlstatuscd        :integer
#  name                :string(255)
#  offer_letter_serial :string(255)
#  photo_content_type  :string(255)
#  photo_file_name     :string(255)
#  photo_file_size     :integer
#  photo_updated_at    :datetime
#  physical            :string(255)
#  race                :string(255)
#  race2               :integer
#  regdate             :date
#  remarks             :text
#  sbirthdt            :date
#  semail              :string(255)
#  specialisation      :string(255)
#  specilisation       :integer
#  ssponsor            :string(255)
#  sstatus             :string(255)
#  stelno              :string(255)
#  updated_at          :datetime
#
