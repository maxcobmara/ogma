class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :userable, polymorphic: true
  has_and_belongs_to_many :roles
  
  belongs_to :college, foreign_key: 'college_id'
  
  acts_as_messageable

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
  
  def self.position_search(query)
    staff_ids=Position.where('name ILIKE(?)or unit ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:staff_id)
    where(userable_id: staff_ids).where(userable_type: "Staff")
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
   [:keyword_search, :position_search]
  end
  
  def mailboxer_name
    self.userable.name
  end
  
  def mailboxer_email(object)
    self.email
  end

  def exams_of_programme
    unit_of_staff = userable.positions.first.unit	 #User.where(id: self.id).first.userable.positions.first.unit
    programme_of_staff = Programme.where('name ILIKE(?)', "%#{unit_of_staff}%").at_depth(0).first
    subjects_ids = programme_of_staff.descendants.at_depth(2).pluck(:id)
    return Exam.where('subject_id IN(?)', subjects_ids).pluck(:id)
  end
  
  def evaluations_of_programme
#     unit_of_prog_mgr = userable.positions.first.unit
#     programme_id_of_prog_mgr = Programme.where('name ILIKE(?)', "%#{unit_of_prog_mgr}%").at_depth(0).first.id
#     return programme_id_of_prog_mgr
    
    #START - fr Catechumen
    #use in authrules - only for Programme Manager, Admin (for Course Evaluation)
    staffpost=Position.where(staff_id: userable_id).first
    unitname=staffpost.unit
    if unitname=="Pengkhususan"  #definitely KP Pengkhususan only
      programmeids=Programme.where(course_type:  ["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]).pluck(:id)
    else
      if roles.pluck(:authname).include?("administration")
        programmeids=Programme.roots.pluck(:id)
      else
        programmeid=Programme.where(name: unitname).first.id
        programmeids=[programmeid]
      end
    end
    programmeids
    #END - fr Catechumen
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
    roles_list=roles.pluck(:authname)
    if Programme.roots.map(&:name).include?(unit) || ["Pengkhususan", "Pos Basik", "Diploma Lanjutan"].include?(unit) && !roles_list.include?("programme_manager")
      if Programme.roots.map(&:name).include?(unit)
        course_id = Programme.where('name=? and ancestry_depth=?', unit,0).first.id
      elsif ["Pengkhususan", "Pos Basik", "Diploma Lanjutan"].include?(unit)
         main_task_first = userable.positions.first.tasks_main
         prog_name_full = main_task_first.scan(/Diploma Lanjutan (.*)/)[0][0].strip if ["Diploma Lanjutan"].include?(unit)    #main_task_first[/Diploma Lanjutan \D{1,}/]  
         prog_name_full = main_task_first.scan(/Pos Basik (.*)/)[0][0].strip if ["Pos Basik"].include?(unit)                            #main_task_first[/Pos Basik \D{1,}/]
         prog_name_full = main_task_first.scan(/Pengkhususan (.*)/)[0][0].strip if ["Pengkhususan"].include?(unit)            #main_task_first[/Pengkhususan \D{1,}/] 
         if prog_name_full.include?(" ")  #space exist, others may exist too
           a_rev=prog_name_full.gsub!(/[^a-zA-Z]/," ")   #in case a consist of comma, etc 
           prog_name=a_rev.split(" ")[0] #intake_desc=group
         else
           prog_name=prog_name_full
         end
         #prog_name_full = main_task_first[/"#{unit}" \D{1,}/]
         #prog_name = prog_name_full.split(" ")[prog_name_full.split(" ").size-1] 
         #prog_name=prog_name_full.split(" ")[0]
         #course_id = Programme.where('name ILIKE(?) and course_type=?', "%#{prog_name}%", unit).first.id   #course_type must match with Pos Basik/....in tasks_main
         course_id = Programme.where('name ILIKE(?)', "%#{prog_name}%").first.id
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
          prog_name_full2 = main_task_first[/Pos Basik \D{1,}/] if ["Pos Basik"].include?(unit)
          prog_name_full2 = main_task_first[/Pengkhususan \D{1,}/] if ["Pengkhususan"].include?(unit)
          #prog_name2 =prog_name_full2.split(" ")[prog_name_full2.split(" ").size-1]
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
  
  def document_recepient
    Document.joins(:staffs).where('staff_id=?', userable_id).pluck(:id)
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
  
  # NOTE - if current user is from 'Unit Kenderaan', display array of 'Unit Kenderaan' - staff_id, otherwise display empty array
  # NOTE - usage: auth rules & asset_loan.rb
  def vehicle_unit_members
    current_unit = Position.where(staff_id: userable_id).first.try(:unit).downcase
    if current_unit.include?('kenderaan') || current_unit.include?('vehicle')
      bb=Position.where('unit ilike(?) or unit ilike(?) or unit ilike(?) or unit ilike(?)', '%kenderaan%', '%Kenderaan%', '%vehicle%', '%Vehicle%').pluck(:staff_id).uniq
    else
      bb=[]
    end
    bb
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
  
  #for Pengarah - access - staff training - ptdo
  def director_subordinates
    mypost=userable.positions.first
    post_name=mypost.name
    if college.code=="amsas"
      dir_sub=[]
      #any of these positions can approve anybody application
      directors_post=Position.where('name ILIKE(?) OR name ILIKE(?) OR name ILIKE(?)', 'Pengarah%', 'Komandan%', 'Ketua Penolong Pengarah%')
      if directors_post.pluck(:staff_id).include?(userable_id)
        directors_post.each{|x|dir_sub+=x.descendants.pluck(:staff_id)}
      else
        dir_sub=[]
      end
    else
      if post_name=="Pengarah"
        dir_sub=mypost.descendants.map(&:staff_id)
      else
        dir_sub=[]
      end
    end
    dir_sub
  end
  
  #for Timbalan Pengarah Urusan / Head of Management side - able to approve - refer auth, should MATCH with StaffAttendance.peeps
  ##not just Timbalan Pengarah (Pengurusan), have to give Pengarah APPROVE access too (plus add roles as 'administration_staff' as well)
  def admin_unitleaders_thumb
#     #academic programmes-start
#     postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
#     dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
#     post_prog=Programme.roots.where(course_type: postbasics).pluck(:name)
#     commonsubject=Programme.where(course_type: 'Commonsubject').pluck(:name).uniq
#     #temp-rescue - make sure this 2 included in Programmes table @ production svr as commonsubject type
#     etc_subject=['Sains Tingkahlaku', 'Anatomi & Fisiologi']
#     #academic programmes-end
#     
#     @head_thumb_ids=[]
#     mypost=userable.positions.first
#     if mypost.name=="Timbalan Pengarah (Pengurusan)"
#       mgmt_units= Position.where('staff_id is not null and unit is not null and unit!=? and unit not in (?) and unit not in (?) and unit not in (?) and unit not in (?)', '', dip_prog, commonsubject, postbasics, etc_subject).pluck(:unit).uniq
#       mgmt_units.each do |department|
#         @head_thumb_ids << Position.unit_department_leader(department).thumb_id unless Position.unit_department_leader(department).nil?
#       end
#       adm_unit_thumbs=@head_thumb_ids
#     else
#       adm_unit_thumbs=[]
#     end
#     adm_unit_thumbs  
    
    ############
    mypost = Position.where(staff_id: userable_id).first
    myunit = mypost.unit
    mythumbid = userable.thumb_id
    iamleader=Position.am_i_leader(userable_id)
    if iamleader== true   #check by roles
      thumbs=Staff.joins(:positions).where('staffs.thumb_id!=? and unit=?', mythumbid, myunit).pluck(:thumb_id)
    else #check by rank / grade
      leader_staffid=Position.unit_department_leader(myunit).id   #return Staff(id) record ofunit/dept leader
      @head_thumb_ids=[]
      
      #academic programmes-start
      postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
      dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
      post_prog=Programme.roots.where(course_type: postbasics).pluck(:name)
      commonsubject=Programme.where(course_type: 'Commonsubject').pluck(:name).uniq
      #temp-rescue - make sure this 2 included in Programmes table @ production svr as commonsubject type
      etc_subject=['Sains Tingkahlaku', 'Anatomi & Fisiologi']
      #academic programmes-end 
      
      if leader_staffid==userable_id #when current user is unit/department leader
        thumbs=Staff.joins(:positions).where('staffs.thumb_id!=? and unit=?', mythumbid, myunit).pluck(:thumb_id)
        #when current user is Pengarah, above shall collect all timbalans thumb id plus academicians leader (Ketua Program)
        if userable_id==Position.roots.first.staff_id
          academic_programmes=dip_prog+post_prog+commonsubject
          academic_programmes.each do |prog|
            @head_thumb_ids << Position.unit_department_leader(prog).thumb_id if Position.where('staff_id is not null and unit=?', prog).count > 0 #staff_id must exist 
          end
          thumbs+=@head_thumb_ids
        end
      else 
        #when superior for current user is Pengarah, then she must be one of timbalans-"Ketua Unit Pengurusan Tertinggi"
        if leader_staffid==Position.roots.first.staff_id 
          if mypost.name.include?("Pengurusan") #Timbalan Pengarah (Pengurusan)
            #management units
            mgmt_units= Position.where('staff_id is not null and unit is not null and unit!=? and unit not in (?) and unit not in (?) and unit not in (?) and unit not in (?)', '', dip_prog, commonsubject, postbasics, etc_subject).pluck(:unit).uniq
            mgmt_units.each do |department|
              @head_thumb_ids << Position.unit_department_leader(department).thumb_id unless Position.unit_department_leader(department).nil?
            end
            thumbs=@head_thumb_ids
          else #other timbalans
            thumbs=[]
          end
        else   
          thumbs=[]
        end
      end
    end
    thumbs
    ############
  end

  #use in - auth_rules(staff attendance)
  def unit_members_thumb
    Staff.where(id: unit_members).pluck(:thumb_id).compact #[5658]
  end
  
  #examquestion - editor access (Kawalan Mutu / Kompetensi) - auth rules
  def editors_programme
    qc_ids=Staff.joins(:positions).where('positions.unit ILIKE(?) OR positions.unit ILIKE(?)', 'Kompetensi', 'Kawalan Mutu').pluck(:id)
    if qc_ids.include?(userable_id)
      #11Nov2016 - temp - must fr Kawalan Mutu / Kompetensi
      programmeid=Programme.roots.where(college_id: College.where(code: 'amsas')).pluck(:id) 
    else
      programmeid=[]
    end
    programmeid
  end
  
  #use in - auth_rules(examquestion) - return [programme_id] for academician
  def lecturers_programme
    mypost = Position.where(staff_id: userable_id).first
    myunit = mypost.unit
    postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
    post_prog=Programme.roots.where(course_type: postbasics)
    dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
    if dip_prog.include?(myunit)
      programmeid=Programme.roots.where(name: myunit).pluck(:id)
    else
      if myunit=="Pengkhususan" && roles.pluck(:authname).include?("programme_manager")
        programmeid=post_prog.pluck(:id)
      elsif postbasics.include?(myunit)
        post_prog.pluck(:name).each do |pname|
          @programmeid=Programme.roots.where(name: pname) if mypost.tasks_main.include?(pname).pluck(:id)
        end
        programmeid=@programmeid
      else
        #programmeid=[0] #default val for admin, common_subjects lecturer too - 11 Nov 2016 -  to check admin?? 
        #TEMP below applied to Amsas lecturer & jurulatih
        programmeid=Programme.roots.pluck(:id)
      end
    end
    programmeid
  end
  
  #use in - auth_rules(examresult) - return [programme_id] for academician (return [] for common subjects lecturer)
  def lecturers_programme2 #to exclude common subjects lecturer
    mypost = Position.where(staff_id: userable_id).first
    myunit = mypost.unit
    postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
    post_prog=Programme.roots.where(course_type: postbasics)
    dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
    common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
    if dip_prog.include?(myunit)
      programmeid=Programme.roots.where(name: myunit).pluck(:id)
    else
      if myunit=="Pengkhususan" && roles.pluck(:authname).include?("programme_manager")
        programmeid=post_prog.pluck(:id)
      elsif postbasics.include?(myunit)
        post_prog.pluck(:name).each do |pname|
          @programmeid=Programme.roots.where(name: pname) if mypost.tasks_main.include?(pname).pluck(:id)
        end
        programmeid=@programmeid
      elsif common_subjects.include?(myunit)
        programmeid=[] #common_subjects lecturer
      elsif roles.pluck(:authname).include?("administration")
        programmeid=[0] #default val for admin
      else
        ##---
	tasks_main = userable.positions[0].tasks_main
	leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
        if leader_unit
              programmeid = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).pluck(:id)
             
        end
	##---
      end
    end
    programmeid
  end
  
  def lecturers_programme_subject
    mypost = Position.where(staff_id: userable_id).first
    myunit = mypost.unit
    # NOTE - posbasic SUP has access to all posbasic programme (PDF only)
    postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
    post_prog=Programme.roots.where(course_type: postbasics)
    #common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
    dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
    if dip_prog.include?(myunit)
      subject_ids=Programme.roots.where(name: myunit).first.descendants.at_depth(2).pluck(:id)
    elsif postbasics.include?(myunit)
      # NOTE - posbasic SUP has access to all posbasic programme (PDF only, restriction on Edit - only creator allowed)
      subject_ids=[]
      post_prog.each do |postb|
        postb.descendants.each{|des|subject_ids << des.id if des.course_type=="Subject" || des.course_type=="Commonsubject"}
      end
    #  post_prog.pluck(:name).each do |pname|
    #    @programmeid=Programme.roots.where(name: pname).pluck(:id) if mypost.tasks_main.include?(pname)
    #  end
    #  subject_ids=Programme.roots.where(id: @programmeid).first.descendants.at_depth(2).pluck(:id)
    # NOTE - common subjects lecturer no longer hv access
    #elsif common_subjects.include?(myunit) 
    #  subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
    else
      subject_ids=Programme.where(course_type: ['Subject', 'Commonsubject']).pluck(:id)
    end
    subject_ids
  end
  
  def by_programme_exams
    mypost = Position.where(staff_id: userable_id).first
    myunit = mypost.unit
    postbasics=['Pengkhususan', 'Pos Basik', 'Diploma Lanjutan']
    post_prog=Programme.roots.where(course_type: postbasics)
    common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
    dip_prog=Programme.roots.where(course_type: 'Diploma').pluck(:name)
    if dip_prog.include?(myunit)
      subject_ids=Programme.roots.where(name: myunit).first.descendants.at_depth(2).pluck(:id)
    elsif postbasics.include?(myunit)
      post_prog.pluck(:name).each do |pname|
        @programmeid=Programme.roots.where(name: pname).pluck(:id) if mypost.tasks_main.include?(pname)
      end
      subject_ids=Programme.roots.where(id: @programmeid).first.descendants.at_depth(2).pluck(:id)
    elsif common_subjects.include?(myunit) 
      subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
    else
      subject_ids=Programme.where(course_type: ['Subject', 'Commonsubject']).pluck(:id)
    end
    exam_ids=Exam.where(subject_id: subject_ids).pluck(:id)
  end
  
  #local messaging - group
  def members_of_msg_group
    group_ids=[]
    Group.all.each do |gr|
      group_ids << gr.id if gr.listing.include?(id)
    end
    group_ids
  end
  
  def role_symbols
   roles.map do |role|
    role.authname.to_sym
   end
  end
end
