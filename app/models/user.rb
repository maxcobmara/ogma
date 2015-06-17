class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :userable, polymorphic: true
  has_and_belongs_to_many :roles

 #Now you can easily fetch the current_user in models by User.current, enjoy it!
  def self.current
    Thread.current[:user]
  end
  def self.current=(user)
    Thread.current[:user] = user
  end
  
  def self.keyword_search(query)
   staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
   student_ids=Student.where('name ILIKE(?)', "%#{query}%").pluck(:id)
   where('(userable_id IN(?) and userable_type=?) OR userable_id IN(?) and userable_type=? ', staff_ids, "Staff", student_ids, "Student")
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
   [:keyword_search]
  end

  def exams_of_programme
    unit_of_staff = userable.positions.first.unit	 #User.where(id: self.id).first.userable.positions.first.unit
    programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
    subjects_ids = programme_of_staff.descendants.at_depth(2).pluck(:id)
    return Exam.where('subject_id IN(?)', subjects_ids).pluck(:id)
  end
  
  def evaluations_of_programme
    unit_of_prog_mgr = userable.positions.first.unit
    programme_id_of_prog_mgr = Programme.where('name ILIKE(?)', "%#{unit_of_prog_mgr}%").at_depth(0).first.id
    return programme_id_of_prog_mgr
  end
  
  def grades_of_programme
    unit_of_staff = userable.positions.first.unit	 #User.where(id: self.id).first.userable.positions.first.unit
    programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
    subjects_ids = programme_of_staff.descendants.at_depth(2).pluck(:id)
    return Grade.where('subject_id IN(?)', subjects_ids).pluck(:id)
  end
  
  def topicdetails_of_programme
    unit_of_staff = userable.positions.first.unit
    if Programme.roots.map(&:name).include?(unit_of_staff)==true
      programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
      topicids = programme_of_staff.descendants.at_depth(3).pluck(:id)
      subtopicids = programme_of_staff.descendants.at_depth(4).pluck(:id)
      topicdetailsids = Topicdetail.where('topic_code IN(?) OR topic_code IN(?)', topicids, subtopicids).pluck(:id)
    else
      #common subject lecturer
      commonsubject_ids= Programme.where(course_type: "Commonsubject").pluck(:id)
      topicids_of_commonsubject = []
      for commons_id in commonsubject_ids
        topicids_of_commonsubject +=Programme.where(id:commons_id).first.descendants.pluck(:id)
      end
      topicdetailsids = Topicdetail.where('topic_code IN(?)', topicids_of_commonsubject).pluck(:id)
    end
    topicdetailsids
  end

  def timetables_of_programme
    unit_of_staff = userable.positions.first.unit
    if Programme.roots.map(&:name).include?(unit_of_staff)==true
      programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
      topicids = programme_of_staff.descendants.at_depth(3).pluck(:id)
      subtopicids = programme_of_staff.descendants.at_depth(4).pluck(:id)
      timetable_in_trainingnote = Trainingnote.where('timetable_id IS NOT NULL').pluck(:timetable_id)
      timetableids = WeeklytimetableDetail.where('(topic IN(?) or topic IN(?))and id IN(?)',topicids, subtopicids, timetable_in_trainingnote).pluck(:id)
      #Use below instead & ignore training note -> copy above accordingly 4 those notes selection related
      timetableids = WeeklytimetableDetail.where('(topic IN(?) or topic IN(?))',topicids, subtopicids).pluck(:id)
      return timetableids
    else
      #common subject lecturer
      []
    end
  end
  
  def under_my_supervision
    unit= userable.positions.first.unit
    if Programme.roots.map(&:name).include?(unit) || ["Pengkhususan", "Pos Basik", "Diploma Lanjutan"].include?(unit)
      if Programme.roots.map(&:name).include?(unit)
        course_id = Programme.where('name=? and ancestry_depth=?', unit,0).first.id
      elsif ["Pengkhususan", "Pos Basik", "Diploma Lanjutan"].include?(unit)
        main_task_first = userable.positions.first.tasks_main
         prog_name_full = main_task_first[/Diploma Lanjutan \D{1,}/] if ["Diploma Lanjutan"].include?(unit)
         prog_name_full = main_task_first[/Pos Basik \d{1,}/] if ["Pos Basik"].include?(unit)
         prog_name_full = main_task_first[/Pengkhususan \d{1,}/] if ["Pengkhususan"].include?(unit)
#         prog_name_full = main_task_first[/"#{unit}" \D{1,}/]
        prog_name = prog_name_full.split(" ")[prog_name_full.split(" ").size-1]
        course_id = Programme.where('name ILIKE(?) and course_type=?', "%#{prog_name}%", unit).first.id
      end 
      main_task = userable.positions.first.tasks_main
      coordinator=main_task[/Penyelaras Kumpulan \d{1,}/]   
      if coordinator
        intake_group=coordinator.split(" ")[2]   #should match 'descripton' field in Intakes table
        intake = Intake.where('programme_id=? and description=?', course_id, intake_group).first.monthyear_intake
        if intake
          @supervised_student =  Student.where('intake=? and course_id=?', intake, course_id).pluck(:id)
        end
      end
    
      @supervised_student=[] if !@supervised_student
      sib_lect_coordinates_groups=[]
      if Programme.roots.map(&:name).include?(unit)
        sib_lect_maintask= Position.where('unit=? and staff_id!=?', unit, userable_id).pluck(:tasks_main)
        sib_lect_maintask.each do |y|
          coordinator2 =  y[/Penyelaras Kumpulan \d{1,}/]
          if coordinator2
            sib_lect_coordinates_groups << coordinator2.split(" ")[2]     #collect group with coordinator
          end
        end
      elsif ["Pengkhususan", "Pos Basik", "Diploma Lanjutan"].include?(unit)
        sib_lect_maintask_all_posbasik= Position.where('unit=? and staff_id!=?', unit, userable_id).pluck(:tasks_main)
        sib_lect_maintask_all_posbasik.each do |x|
          coordinator2 =  x[/Penyelaras Kumpulan \d{1,}/]
          prog_name_full2 = main_task_first[/Diploma Lanjutan \D{1,}/] if ["Diploma Lanjutan"].include?(unit)
          prog_name_full2 = main_task_first[/Pos Basik \d{1,}/] if ["Pos Basik"].include?(unit)
          prog_name_full2 = main_task_first[/Pengkhususan \d{1,}/] if ["Pengkhususan"].include?(unit)
          prog_name2 =prog_name_full2.split(" ")[prog_name_full2.split(" ").size-1]
          if coordinator2 && prog_name==prog_name2
            sib_lect_coordinates_groups << coordinator2.split(" ")[2]     #collect group with coordinator
          end
        end
      end
      
      #Either I'm a coordinator (or not) of any student group/intake/batch, is there any group/intake/batch w/o coordinator that requires me to become ONE OF authorising programme lecturer (to approve student leave applications)
      #limit checking on existing leaveforstudent records 
    
      leave_applicant_ids =Leaveforstudent.all.pluck(:student_id) #ALL student applying leave
      applicant_of_current_prog = Student.where('id IN(?) and course_id=?', leave_applicant_ids, course_id)
      #intake_for_applicant_current_prog = Student.find(:all, :conditions=>['id IN (?)', applicant_of_current_prog]).map(&intake)
      #intake_for_applicant_current_prog = Student.find(:all, :conditions=>['id IN(?) and course_id=?', leave_applicant_ids, course_id]).map(&:intake)
      applicant_of_current_prog.group_by{|x|x.intake}.each do |intatake, applicants|
        intake2 =Intake.where('programme_id=? and monthyear_intake=?', course_id, intatake).first
        if intake2
	  intake2_group = intake2.description
          w_coordinator=sib_lect_coordinates_groups.include?(intake2_group)
	  @supervised_student+= applicants if !w_coordinator
        else
	  #this student group definitely got no coordinator as their intake not even exist in Intakes table
	  #add these applicants to supervised_student array! note 'applicants' is an array
	  @supervised_student+= applicants 
        end
      end 
      return @supervised_student
    else
      return []
    end
  end
  
  ###Use in Ptdo(for use in auth_rules & Edit pages (approve)) - start
  def unit_members#(current_unit, current_staff, current_roles)
    #Academicians & Mgmt staff : "Teknologi Maklumat", "Perpustakaan", "Kewangan & Akaun", "Sumber Manusia","logistik", "perkhidmatan" ETC.. - by default staff with the same unit in Position will become unit members, whereby Ketua Unit='unit_leader' role & Ketua Program='programme_manager' role.
    #Exceptional for - "Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor" (subunit of Pentadbiran), Ketua Unit='unit_leader' with unit in Position="Pentadbiran" Note: whoever within these unit if wrongly assigned as 'unit_leader' will also hv access for all ptdos on these unit staff
    
    current_staff=userable_id
    exist_unit_of_staff_in_position = Position.where('unit is not null and staff_id is not null').map(&:staff_id).uniq
    if exist_unit_of_staff_in_position.include?(current_staff)   
      
      current_unit=userable.positions.first.unit
      #replace current_unit value if academician also a Unit Leader (23)
      current_roles=User.where(userable_id: userable_id).first.roles.map(&:name) #"Unit Leader" #userable.roles.map(&:role_id) 
      current_unit=unit_lead_by_academician if current_roles.include?("Unit Leader") && Programme.roots.map(&:name).include?(current_unit)
      
      if current_unit=="Pentadbiran"
        unit_members = Position.where('unit=? OR unit=? OR unit=? OR unit=?', "Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor").map(&:staff_id).uniq-[nil]+Position.where('unit=?', current_unit).map(&:staff_id).uniq-[nil]
      elsif ["Teknologi Maklumat", "Pusat Sumber", "Kewangan & Akaun", "Sumber Manusia"].include?(current_unit) || Programme.roots.map(&:name).include?(current_unit)
        unit_members = Position.where('unit=?', current_unit).map(&:staff_id).uniq-[nil]
      else #logistik & perkhidmatan inc."Unit Perkhidmatan diswastakan / Logistik" or other UNIT just in case - change of unit name, eg. Perpustakaan renamed as Pusat Sumber
        unit_members = Position.where('unit ILIKE(?)', "%#{current_unit}%").map(&:staff_id).uniq-[nil] 
      end
    else
      unit_members = []#Position.find(:all, :conditions=>['unit=?', 'Teknologi Maklumat']).map(&:staff_id).uniq-[nil]
    end
    unit_members   #collection of staff_id (member of a unit/dept) - use in model/user.rb (for auth_rules)
    #where('staff_id IN(?)', unit_members) ##use in ptdo.rb (controller - index)
  end
  
  #call this method if academician also lead a mgmt unit
  def unit_lead_by_academician
    main_tasks=userable.positions.first.tasks_main
    if main_tasks.include?("Ketua Unit")   
      mgmt_unit=main_tasks.scan(/Ketua Unit(.*),/)[0][0].strip
    else
      mgmt_unit=""
    end
    mgmt_unit
  end
  ###Use in Ptdo(for use in auth_rules & Edit pages (approve)) - end
  
  #for Timbalan Pengarah Pengurusan only - for accessible of staff training application status list w/o assignment on 'Administration' role
  def admin_subordinates
    mypost=userable.positions.first
    post_name=mypost.name
    if post_name=="Timbalan Pengarah (Pengurusan)"
      adm_sub=mypost.descendants.map(&:staff_id)
    else
      adm_sub=[]
    end
    adm_sub
  end

  def role_symbols
   roles.map do |role|
    role.authname.to_sym
   end
  end
end
