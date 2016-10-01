class Student < ActiveRecord::Base
  include StudentsHelper
  
  before_save  :titleize_name
  validates_presence_of     :icno, :name, :sstatus, :stelno, :ssponsor, :gender, :sbirthdt, :mrtlstatuscd, :intake,:course_id
  validates_presence_of :birthplace, :religion, :if => :college_is_amsas?
  validates_numericality_of :icno, :stelno
  #validates_length_of       :icno, :is =>12
  validates_uniqueness_of   :icno
  #validates_format_of       :name, :with => /^[a-zA-Z'`\/\.\@\ ]+$/, :message => I18n.t('activerecord.errors.messages.illegal_char') #add allowed chars between bracket
  has_attached_file :photo,
                    :url => "/assets/students/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/students/:id/:style/:basename.:extension",
                    :styles => { :original => "250x300>", :thumbnail => "50x60" , :form => "80x90"} #default size of uploaded image
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  
  has_many :users, as: :userable
  has_and_belongs_to_many :klasses          #has_and_belongs_to_many :programmes

  belongs_to :course,         :class_name => 'Programme', :foreign_key => 'course_id'       #Link to Programme
  belongs_to :intakestudent,  :class_name => 'Intake',    :foreign_key => 'intake_id'       #Link to Model intake
  belongs_to :rank, :foreign_key => 'rank_id'

  #has_one   :user,              :dependent => :destroy                                      #Link to Model user
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

  #has_many :sdiciplines, :foreign_key => 'student_id'
  #has_many :std, :class_name => 'Sdicipline', :foreign_key => 'student_id'
  
  has_many          :kins, :dependent => :destroy
  accepts_nested_attributes_for :kins, :reject_if => lambda { |a| a[:kintype_id].blank? }
  
  has_one :student, foreign_key: 'student_id'

  def self.course_search(query)
    programme_ids = Programme.roots.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    where(course_id: programme_ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:course_search]
  end
  
  def intake_course
    "#{intake}"+","+"#{course_id}"
  end
  
  def student_list
    "#{icno}"+" "+"#{name}"
  end
  
  def student_with_rank
    "#{rank.try(:shortname)} #{name}"
  end

  def render_race
     (Student::RACE.find_all{|disp, value| value == race2.to_i}).map {|disp, value| disp} [0]
  end
  
  def render_marital
    (Student::MARITAL_STATUS.find_all{|disp, value| value == mrtlstatuscd.to_s}).map {|disp, value| disp} [0]
  end
  
  def render_bloodtype
    (Student::BLOOD_TYPE.find_all{|disp, value| value == bloodtype.to_s}).map {|disp, value| disp} [0]
  end
  
  def render_religion
     (Student::RELIGION.find_all{|disp, value| value == religion}).map {|disp, value| disp} [0]
  end
  
  def render_birthplace
     (Student::STATECD.find_all{|disp, value| value == birthplace}).map {|disp, value| disp} [0]
  end
  
  def college_is_amsas?
    college_id==2
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

		  I18n.t("student.discipline.year")+" #{@year}, Semester #{@semester}"

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
      #intake.to_date.strftime("%b %Y")+" | #{course.course_type} - #{course.name}"
#     if intake_id?
#       "#{intakestudent.monthyear_intake.strftime("%b %Y")} | #{course.programme_list}"
#     else
      "#{intake.to_date.strftime("%b %Y")} | #{course.programme_list}"
    #end
  end

  #group by intake
 # def isorter
 #   suid = intake_id
 #   Intake.find(:all, :select => "name", :conditions => {:id => suid}).map(&:name)
 # end

  def formatted_mykad
    if icno.size==12
    "#{icno[0,6]}-#{icno[6,2]}-#{icno[-4,4]}"
    else
      icno
    end
  end

  def formatted_mykad_and_student_name
    " #{formatted_mykad} #{name}"
  end

  def matrix_name
    " #{matrixno} #{name}"
  end
  
  def matrix_name_programme
     "#{matrix_name} (#{programme_name})"
  end
  
  def programme_name
    if course.blank?
      "N/A"
    else
      "#{course.name}"
    end
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

   def self.get_intake(main_semester, main_year, programme)
     current_year = Date.today.year
     current_month = Date.today.month     #for testing - assign value as 8 (August)
     if current_month < 7
       current_semester = 1
       current_sem_month = 1              #Sem January
     else
       current_semester = 2
       current_sem_month = 7              #Sem July
     end
     if main_semester == 1
       intake_month = current_sem_month
       if main_year >1
         intake_year = current_year-(main_year-1)
       else
         intake_year = current_year
       end
     elsif main_semester == 2
       if current_sem_month == 1
         intake_month = 7
         intake_year = current_year-main_year
       else
         intake_month = 1
         intake_year = current_year-(main_year-1)
       end
     end
     #### Kebidanan only - start
     if Programme.find(programme).name=="Kebidanan"
        if current_month >=3 && current_month < 10
          current_sem_month = 3
        else (current_month > 0 && current_month < 3) || (current_month >=9 && current_month <=12)
          current_sem_month = 9
        end
        if main_semester == 1
          intake_month = current_sem_month
          intake_year = current_year
        elsif main_semester == 2
          if current_sem_month==3
            intake_year = current_year-1
            intake_month = 9
          elsif current_sem_month==9
            intake_month = 3
            intake_year = current_year
          end
        end
     end
     ####Kebidanan only - end
     return Date.new(intake_year, intake_month,1)
   end
   
   def self.get_intake_repeat(main_semester, main_year, programme)
     current_year = Date.today.year
     current_month = Date.today.month     #for testing - assign value as 8 (August)
     if current_month < 7 
       current_semester = 2
       current_sem_month = 7              #Sem January
     else 
       current_semester = 1 
       current_sem_month = 1              #Sem July
     end 
     if main_semester == 1 
       intake_month = current_sem_month 
       if main_year >1 
         intake_year = current_year-main_year
#        else                                     #no repeaters among 1st sem, 1st year students, all freshies.
#          intake_year = current_year 
       end 
     elsif main_semester == 2
       if current_sem_month == 1 
         intake_month = 1
         intake_year = current_year-(main_year-1) 
       else 
         intake_month = 1 
         intake_year = current_year-main_year    
       end 
     end 
     return Date.new(intake_year, intake_month,1) 
   end

   def self.get_intake_repeat2(main_semester, main_year, programme) #Sem 1, Year 3 (1/1/2012)
     current_year = Date.today.year
     current_month = Date.today.month     
     if current_month < 7 
       intake_month = 1              #Sem January
     else 
       intake_month = 7              #Sem July
     end      
     intake_year = current_year-main_year
     return Date.new(intake_year, intake_month,1) 
   end
   
   def self.get_student_by_intake_gender_race(main_semester, main_year, gender, programme, race)
     intake_start = Student.get_intake(main_semester, main_year, programme)
     intake_end = intake_start.end_of_month
     current_students=Student.where('intake >=? AND intake<=? AND course_id=? AND race2=? AND gender=? AND sstatus=?',intake_start, intake_end, programme, race, gender, 'Current')
     if !(main_semester==1 && main_year==1)
       intake_repeat_start = Student.get_intake_repeat(main_semester, main_year, programme)
       intake_repeat_end = intake_repeat_start.end_of_month
       repeat_students = Student.where('intake >=? AND intake<=? AND course_id=? AND race2=? AND gender=? and sstatus=? AND sstatus_remark not ILIKE(?)', intake_repeat_start, intake_repeat_end, programme, race, gender, 'Repeat', '%,%')
       #repeat_students = Student.find(:all, :conditions => ['intake >=? AND intake<=? AND course_id=? AND race2=? AND gender=? and sstatus=?', "2014-01-01", "2014-01-31", 1, 11, 1, 'Repeat']) 
       #for checking - 950423-12-6289, Idzham, Jurupulih Cara Kerja(1), Male, Kedayan(11), Intake Jan 2014, SWITCH between sstatus='Current' & 'Repeat'
       
       #downgrade by another 1 sem  (repeat 2 semesters)
       if !(main_semester==2 && main_year==1)  #&& main_semester==2 #1
         intake_repeat2_start = Student.get_intake_repeat2(main_semester, main_year, programme)
         intake_repeat2_end = intake_repeat2_start.end_of_month
         intakemonth=intake_repeat2_start.month
         if intakemonth == main_semester || intakemonth-5 == main_semester
           repeat_students2 = Student.where('intake >=? AND intake<=? AND course_id=? AND race2=? and gender=? and sstatus=? AND sstatus_remark ILIKE(?)', intake_repeat2_start, intake_repeat2_end, programme, race, gender, 'Repeat', '%,%')
         end
       end 
       
     end
     all_students = []
     all_students += current_students if current_students
     all_students+=repeat_students if repeat_students 
     all_students+=repeat_students2 if repeat_students2
     return all_students
   end

   def self.get_student_by_intake_gender(main_semester, main_year, gender, programme)
     intake_start = Student.get_intake(main_semester, main_year, programme)
     intake_end = intake_start.end_of_month
     current_students=Student.where('intake >=? AND intake<=? AND course_id=? AND gender=? AND race2 IS NOT NULL and sstatus=?',intake_start, intake_end, programme, gender, 'Current')
     if !(main_semester==1 && main_year==1)
       intake_repeat_start = Student.get_intake_repeat(main_semester, main_year, programme)
       intake_repeat_end = intake_repeat_start.end_of_month
       repeat_students = Student.where('intake >=? AND intake<=? AND course_id=? AND gender=? and race2 IS NOT NULL and sstatus=? AND sstatus_remark not ILIKE(?)', intake_repeat_start, intake_repeat_end, programme, gender, 'Repeat', '%,%')
       #repeat_students = Student.find(:all, :conditions => ['intake >=? AND intake<=? AND course_id=? AND gender=? and sstatus=?', "2014-01-01", "2014-01-31", 1, 1, 'Repeat']) 
       #for checking - 950423-12-6289, Idzham, Jurupulih Cara Kerja(1), Male, Kedayan(11), Intake Jan 2014, SWITCH between sstatus='Current' & 'Repeat'
       
       #downgrade by another 1 sem  (repeat 2 semesters)
       if !(main_semester==2 && main_year==1)  #&& main_semester==2 #1
         intake_repeat2_start = Student.get_intake_repeat2(main_semester, main_year, programme)
         intake_repeat2_end = intake_repeat2_start.end_of_month
         intakemonth=intake_repeat2_start.month
         if intakemonth == main_semester || intakemonth-5 == main_semester
           repeat_students2 = Student.where('intake >=? AND intake<=? AND course_id=? AND race2 IS NOT NULL and gender=? and sstatus=? AND sstatus_remark ILIKE(?)', intake_repeat2_start, intake_repeat2_end, programme, gender, 'Repeat', '%,%')
         end
       end 
       
     end
     
     all_students = []
     all_students += current_students if current_students
     all_students+=repeat_students if repeat_students
     all_students+=repeat_students2 if repeat_students2
     return all_students
   end
   
   #####Laporan Bilangan Pelatih (Lapor Diri)
   def self.get_lapor_diri(main_semester, main_year, gender, programme)
     students_all_6intakes = Student.get_student_by_6intake(programme)
     @students_6intakes_ids = students_all_6intakes.map(&:id)
     intake_start = Student.get_intake(main_semester, main_year, programme)
     intake_end = intake_start.end_of_month
     existing_students=Student.where('intake >=? AND intake<=? AND course_id=? AND gender=? AND race2 IS NOT NULL and id IN(?) and (sstatus=? OR sstatus=?)', intake_start, intake_end, programme, gender,@students_6intakes_ids ,'Current', 'Repeat')
     existing_students
   end
   #####

   def self.get_student_by_6intake(programme) #return all students for these 6 intake - valid & invalid
     intake_start1 = Student.get_intake(1, 1, programme)
     intake_end1 = intake_start1.end_of_month
     intake_start2 = Student.get_intake(2, 1, programme)
     intake_end2 = intake_start2.end_of_month
     intake_start3 = Student.get_intake(1, 2, programme)
     intake_end3 = intake_start3.end_of_month
     intake_start4 = Student.get_intake(2, 2, programme)
     intake_end4 = intake_start4.end_of_month
     intake_start5 = Student.get_intake(1, 3, programme)
     intake_end5 = intake_start5.end_of_month
     intake_start6 = Student.get_intake(2, 3, programme)
     intake_end6 = intake_start6.end_of_month
     current_students = Student.where('((intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?)) AND course_id=? and sstatus=?',intake_start1, intake_end1,intake_start2, intake_end2, intake_start3, intake_end3, intake_start4, intake_end4,intake_start5, intake_end5,intake_start6, intake_end6,programme, 'Current')
     
     intake_repeat_start2 = Student.get_intake_repeat(2, 1, programme)
     intake_repeat_end2 = intake_repeat_start2.end_of_month
     intake_repeat_start3 = Student.get_intake_repeat(1, 2, programme)
     intake_repeat_end3 = intake_repeat_start3.end_of_month
     intake_repeat_start4 = Student.get_intake_repeat(2, 2, programme)
     intake_repeat_end4 = intake_repeat_start4.end_of_month
     intake_repeat_start5 = Student.get_intake_repeat(1, 3, programme)
     intake_repeat_end5 = intake_repeat_start5.end_of_month
     intake_repeat_start6 = Student.get_intake_repeat(2, 3, programme)
     intake_repeat_end6 = intake_repeat_start6.end_of_month
     repeat_students= Student.where('( (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?)) AND course_id=? AND sstatus=? AND sstatus_remark not ILIKE(?)',intake_repeat_start2, intake_repeat_end2, intake_repeat_start3, intake_repeat_end3, intake_repeat_start4, intake_repeat_end4,intake_repeat_start5, intake_repeat_end5,intake_repeat_start6, intake_repeat_end6,programme, 'Repeat', '%,%')
     
     intake_repeat2_start3 = Student.get_intake_repeat2(1, 2, programme)
     intake_repeat2_end3 = intake_repeat2_start3.end_of_month
     intake_repeat2_start4 = Student.get_intake_repeat2(2, 2, programme)
     intake_repeat2_end4 = intake_repeat2_start4.end_of_month
     intake_repeat2_start5 = Student.get_intake_repeat2(1, 3, programme)
     intake_repeat2_end5 = intake_repeat2_start5.end_of_month
     intake_repeat2_start6 = Student.get_intake_repeat2(2, 3, programme)
     intake_repeat2_end6 = intake_repeat2_start6.end_of_month
     repeat2_students= Student.where('( (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?) OR (intake >=? AND intake<=?)) AND course_id=? AND sstatus=? AND sstatus_remark ILIKE(?)', intake_repeat2_start3, intake_repeat2_end3, intake_repeat2_start4, intake_repeat2_end4,intake_repeat2_start5, intake_repeat2_end5,intake_repeat2_start6, intake_repeat2_end6,programme, 'Repeat', '%,%')
     
     all_students = []
     all_students += current_students if current_students
     all_students+=repeat_students if repeat_students
     all_students+=repeat2_students if repeat2_students
     return all_students
   end

   def self.get_student_by_2intake(programme) #return all students for these 6 intake - valid & invalid
     intake_start1 = Student.get_intake(1, 1, programme)
     intake_end1 = intake_start1.end_of_month
     intake_start2 = Student.get_intake(2, 1, programme)
     intake_end2 = intake_start2.end_of_month
     current_students = Student.where('((intake >=? AND intake<=?) OR (intake >=? AND intake<=?)) AND course_id=? and sstatus=?',intake_start1, intake_end1,intake_start2, intake_end2, programme, 'Current')
     
     intake_repeat_start2 = Student.get_intake_repeat(2, 1, programme)
     intake_repeat_end2 = intake_repeat_start2.end_of_month
     #intake_repeat_start3 = Student.get_intake_repeat(1, 2, programme)
     #intake_repeat_end3 = intake_repeat_start3.end_of_month
     repeat_students= Student.where('( (intake >=? AND intake<=?)) AND course_id=? AND sstatus=? AND sstatus_remark not ILIKE(?)',intake_repeat_start2, intake_repeat_end2, programme, 'Repeat', '%,%')
     
     intake_repeat2_start3 = Student.get_intake_repeat2(1, 2, programme)
     intake_repeat2_end3 = intake_repeat2_start3.end_of_month
     intake_repeat2_start4 = Student.get_intake_repeat2(2, 2, programme)
     intake_repeat2_end4 = intake_repeat2_start4.end_of_month
     repeat2_students= Student.where('((intake >=? AND intake<=?) OR (intake >=? AND intake<=?)) AND course_id=? AND sstatus=? AND sstatus_remark ILIKE(?)', intake_repeat2_start3, intake_repeat2_end3, intake_repeat2_start4, intake_repeat2_end4,programme, 'Repeat', '%,%')
     
     all_students = []
     all_students += current_students if current_students
     all_students+=repeat_students if repeat_students
     all_students+=repeat2_students if repeat2_students
     return all_students
   end

# ------------------------------code for repeating field qualification---------------------------------------------------
 has_many :qualifications, :dependent => :destroy
 accepts_nested_attributes_for :qualifications, :allow_destroy => true, :reject_if => lambda { |a| a[:level_id].blank? }

 has_many :kins, :dependent => :destroy
 accepts_nested_attributes_for :kins, :allow_destroy => true, :reject_if => lambda { |a| a[:kintype_id].blank? }
 validates_associated :kins

 has_many :spmresults, :dependent => :destroy
 accepts_nested_attributes_for :spmresults, :allow_destroy => true, :reject_if => lambda { |a| a[:spm_subject].blank? }

 #export excel section ---
 
  def self.to_csv2(options = {})
    CSV.generate(options) do |csv|
        csv << [I18n.t('student.students.list')] #title added
        csv << [] #blank row added
        csv << [I18n.t('student.students.icno'), I18n.t('student.students.name'), I18n.t('student.students.matrixno'), I18n.t('student.students.course_id'), I18n.t('student.students.intake_id'), I18n.t('student.students.regdate'), I18n.t('student.students.end_training'),I18n.t('student.students.offer_letter_serial'),I18n.t('student.students.ssponsor'),"Status",I18n.t('student.students.status_remark'), I18n.t('student.students.gender'), I18n.t('student.students.race'), I18n.t('student.students.mrtlstatuscd'),I18n.t('student.students.stelno'), I18n.t('student.students.semail'), I18n.t('student.students.sbirthd'), I18n.t('student.students.physical'), I18n.t('student.students.allergy'), I18n.t('student.students.disease'),I18n.t('student.students.bloodtype'), I18n.t('student.students.medication'),I18n.t('student.students.remark')+" ("+I18n.t('student.students.medical')+")", I18n.t('student.students.address'), I18n.t('student.students.remark')]
        all.each do |student|
          csv << [student.formatted_mykad, student.name, student.display_matrixno, student.display_programme, student.display_intake, student.display_regdate,student.display_enddate, student.display_offer_letter, student.ssponsor, student.display_status, student.display_sstatus_remark, student.display_gender, student.display_race, student.display_marital,  "\'"+student.try(:stelno)+"\'", student.display_semail, student.display_birthdate, student.display_physical, student.display_allergy, student.display_disease, student.display_bloodtype, student.display_medication, student.display_medicalremarks,  student.display_address, student.display_courseremarks]
        end
      end
  end
 
 def self.to_csv(options = {})
    @programme_id = all[0].course_id
    students_all_6intakes = Student.get_student_by_6intake(@programme_id)
    @students_6intakes_ids = students_all_6intakes.map(&:id)
    students_all_6intakes_count = students_all_6intakes.count
    @valid = Student.where('course_id=? AND race2 IS NOT NULL AND id IN(?)',@programme_id, @students_6intakes_ids)
    @student = Student.all
    programme_name=Programme.find(@programme_id).programme_list
   
    CSV.generate(options) do |csv|
        csv << ["BAHAGIAN PENGURUSAN LATIHAN"]
        csv << ["KEMENTERIAN KESIHATAN MALAYSIA"]
        csv << ["MAKLUMAT KUMPULAN ETNIK PELATIH DI INSTITUSI LATIHAN KEMENTERIAN KESIHATAN MALAYSIA"]
        if Date.today.month < 7
            csv << ["INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", nil, nil,nil, nil,nil, nil,nil, nil,nil, nil,nil, nil,nil, nil,nil, nil,nil, nil,nil, nil,nil,nil, nil,"**SESI:JAN-JUN #{Date.today.year}  JUL-DIS......."]
        else
            csv << ["INSTITUSI LATIHAN : KOLEJ SAINS KESIHATAN BERSEKUTU JOHOR BAHRU", "**SESI:JAN-JUN......  JUL-DIS #{Date.today.year}"]
        end
        csv << [] #blank row added  
        csv << ["JENIS PROGRAM/ KURSUS","KUMP","Jantina", "Melayu","Cina","India","Org Asli","Bajau","Murut","Brunei","Bisaya","Kadazan","Suluk","Kedayan","Iban","Kadazan Dusun","Sungai","Siam","Malanau","Bugis","Bidayuh","Momogun Rungus","Dusun","Lain-lain","JUMLAH"]

        csv << [programme_name,"T1SI","P","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(1, 1, 2,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(1, 1, 2,@programme_id).count}"]

        csv << [nil,nil,"L","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(1, 1, 1,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(1, 1, 1,@programme_id).count}"]

        csv << [nil, "T1SII","P","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(2, 1, 2,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(2, 1, 2,@programme_id).count}"]

        csv << [nil,nil,"L","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(2, 1, 1,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(2, 1, 1,@programme_id).count}"]

        csv << [nil,"T2SI","P","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(1, 2, 2,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(1, 2, 2,@programme_id).count}"]

        csv << [nil,nil,"L","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(1, 2, 1,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(1, 2, 1,@programme_id).count}"]

         csv << [nil,"T2SII","P","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(2, 2, 2,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(2, 2, 2,@programme_id).count}"]

         csv << [nil, nil,"L","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(2, 2, 1,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(2, 2, 1,@programme_id).count}"]

         csv << [nil,"T3SI","P","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(1, 3, 2,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(1, 3, 2,@programme_id).count}"]

         csv << [nil, nil,"L","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(1, 3, 1,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(1, 3, 1,@programme_id).count}"]

         csv << [nil, "T3SII","P","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(2, 3, 2,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(2, 3, 2,@programme_id).count}"]
	 
         csv << [nil, nil,"L","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 1).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 2).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 3).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 4).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 5).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 6).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 7).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 8).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 9).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 10).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 11).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 12).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 13).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 14).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 15).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 16).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 17).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 18).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 19).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 20).count}","#{Student.get_student_by_intake_gender_race(2, 3, 1,@programme_id, 21).count}","#{Student.get_student_by_intake_gender(2, 3, 1,@programme_id).count}"]
 
         csv << [nil,"JUMLAH",nil, "#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 1,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 2,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 3,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 4,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 5,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 6,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 7,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 8,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 9,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 10,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 11,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 12,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 13,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 14,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 15,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 16,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 17,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 18,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 19,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 20,@students_6intakes_ids).count}","#{@total_by_race=Student.where('course_id=? AND race2=? AND id IN (?)', @programme_id, 21,@students_6intakes_ids).count}","#{@valid.count}"]

      end
  end
  
  def self.import(file) 
    spreadsheet = Spreadsheet2.open_spreadsheet(file) 
    result = StudentsHelper.update_student(spreadsheet)
    return result
  end 

  def self.messages(import_result) 
    StudentsHelper.msg_import(import_result)
  end
  
  def self.messages2(import_result) 
    StudentsHelper.msg_import2(import_result)
  end
  
  def self.groupby_programme
    studentby_programmelists=Student.where('course_id is not null').group_by{|x|x.course.programme_list}
    @groupped_student=[]
    studentby_programmelists.each do |programmelist, students|
      pg_students=[[I18n.t('helpers.prompt.select_student'), '']]
      students.each{|student|pg_students << [student.matrix_name, student.id]} 
      @groupped_student << [programmelist, pg_students]
    end
    @groupped_student
  end
  
  def self.groupby_posbasics
    posbasics=Programme.where(course_type: ['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']).pluck(:id)
    studentby_programmelists=Student.where('course_id is not null').where(course_id: posbasics).group_by{|x|x.course.programme_list}
    @groupped_student=[]
    studentby_programmelists.each do |programmelist, students|
      pg_students=[[I18n.t('helpers.prompt.select_student'), '']]
      students.each{|student|pg_students << [student.matrix_name, student.id]} 
      @groupped_student << [programmelist, pg_students]
    end
    @groupped_student
  end
  
  def self.groupby_oneprogramme(progid)
    studentby_programmelists=Student.where(course_id: progid).order(matrixno: :asc).group_by{|x|x.course.programme_list}
    @groupped_student=[]
    studentby_programmelists.each do |programmelist, students|
      pg_students=[[I18n.t('helpers.prompt.select_student'), '']]
      students.each{|student|pg_students << [student.matrix_name, student.id]} 
      @groupped_student << [programmelist, pg_students]
    end
    @groupped_student
  end
  
STATUS = [
           #  Displayed       stored in db
            [ I18n.t('student.students.current'),"Current" ],
            [ I18n.t('student.students.graduated'),"Graduated" ],
            [ I18n.t('student.students.repeat'), "Repeat" ],
            [ I18n.t('student.students.on_leave'), "On Leave" ],
            [ I18n.t('student.students.transfer_college'), "Transfer College"],
            [ I18n.t('student.students.expelled'), "Expelled"]
] 

STATUS_AMSAS = [
           #  Displayed       stored in db
               ['Asas Pegawai', 'Asaspeg' ],
               ['Asas LLP', 'Asasllp'],
               ['Lanjutan Pegawai', 'Lanpeg'],
               ['Lanjutan LLP', 'Lanllp']
] 

STATUS_COMBINE = [
           #  Displayed       stored in db
            [ I18n.t('student.students.current'),"Current" ],
            [ I18n.t('student.students.graduated'),"Graduated" ],
            [ I18n.t('student.students.repeat'), "Repeat" ],
            [ I18n.t('student.students.on_leave'), "On Leave" ],
            [ I18n.t('student.students.transfer_college'), "Transfer College"],
            [ I18n.t('student.students.expelled'), "Expelled"],
            ['Asas Pegawai', 'Asaspeg' ],
            ['Asas LLP', 'Asasllp'],
            ['Lanjutan Pegawai', 'Lanpeg'],
            ['Lanjutan LLP', 'Lanllp']
] 
SPONSOR = [
         #  Displayed       stored in db
         [ "Kementerian Kesihatan Malaysia","KKM" ],
         [ "Suruhanjaya Perkhidmatan Awam","SPA" ],
         [ "Swasta","swasta" ],
         [ "Sendiri", "FaMa" ]
]

GENDER = [
        #  Displayed       stored in db
        [ I18n.t('student.students.male'),"1" ],
        [ I18n.t('student.students.female'),"2" ]
]

#Pls note 'race2' field is for race whereas 'race' field is for etnic
RACE = [
        #  Displayed       stored in db
        [ "Melayu", 1 ],
        [ "Cina", 2],
        [ "India", 3],
        [ "Orang Asli", 4],
        [ "Bajau", 5],
        [ "Murut",6],
        [ "Brunei",7],
        [ "Bisaya",8],
        [ "Kadazan",9],
        [ "Suluk",10],
        [ "Kedayan",11],
        [ "Iban",12],
        [ "Kadazan Dusun",13],
        [ "Sungal",14],
        [ "Siam",15],
        [ "Melanau",16],
        [ "Bugis",17],
        [ "Bidayuh",18],
        [ "Momogun Rungus",19],
        [ "Dusun",20],
        [ "Lain-Lain",21]
]

SESSION = [
        #  Displayed       stored in db
        [ "January","1" ],
        [ "July","2" ]
  ]

MARITAL_STATUS = [
        #  Displayed       stored in db
        [ "Bujang","1" ],
        [ "Berkahwin","2" ],
        [ "Lain Lain", "3"]
        #[ "Balu", "3" ],[ "Duda", "4" ],[ "Bercerai", "5" ],[ "Berpisah", "6" ],[ "Tiada Maklumat", "9" ]
]

CLASS= [
          #  Displayed       stored in db
          [ "1","1" ],
          [ "2","2" ],
          [ "3", "3" ],
          [ "4", "4" ],
          [ "5", "5" ],
          [ "6", "6" ]
    ]

BLOOD_TYPE = [
             #  Displayed       stored in db
             [ "O-",          "1" ],
             [ "O+",    "2" ],
             [ "A-", "3" ],
             [ "A+", "4" ],
             [ "B-", "5" ],
             [ "B+", "6" ],
             [ "AB-", "7" ],
             [ "AB+", "8" ]
    ]

STATECD = [
    #  Displayed       stored in db
    [ "Johor",                            1],
    [ "Kedah",                            2],
    [ "Kelantan",                         3 ],
    [ "Melaka",                           4],
    [ "Negeri Sembilan",                  5 ],
    [ "Pahang",                           6 ],
    [ "Pulau Pinang",                     7 ],
    [ "Perak",                            8 ], 
    [ "Perlis",                           9 ],
    [ "Selangor",                         10 ], 
    [ "Terengganu",                       11 ], 
    [ "Sabah",                            12 ], 
    [ "Sarawak",                          13 ],
    [ "Wilayah Persekutuan Kuala Lumpur", 14 ],
    [ "Wilayah Persekutuan Labuan",       15 ],
    [ "Wilayah Persekutuan Putrajaya",    16 ],
    [ "Luar Negara",                      98 ],       
]
 
 RELIGION = [
       #  Displayed       stored in db
       [ "Islam",    1],
       [ "Buddha",   2 ],
       [ "Hindu",    3 ],
       [ "Kristian", 5],
       [ "Others",   4 ],
 ]


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
#religion :integer
#birthplace :integer