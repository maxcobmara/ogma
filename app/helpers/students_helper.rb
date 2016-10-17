module StudentsHelper

  def year_and_sem
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

    "#{(I18n.t('time.years')).singularize.titleize} #{@year}, Semester #{@semester}"
  end
  
  def intake_num
    intake_month = intake.strftime("%m")
    intake_year = intake.strftime("%Y")
    if intake_month.to_i < 7 
      mnth_group = 1
    elsif intake_month.to_i > 6
      mnth_group = 2
    end
    "#{mnth_group}/#{intake_year}"
  end
  
  #for Export Excel -- start
  def display_matrixno
    unless matrixno.blank? 
      a="#{matrixno}"
    else                      #blank includes: nil, false, [], {}, ""
      a="\'\'"                 #use in Excel (remove '' from empty cells)
      #a=nil                 #use in PDF (remove '' from empty cells))
    end
  end
 
  def display_race
    unless race2.nil? 
      a="#{((Student::RACE.find_all{|disp, value| value == race2.to_i}).map {|disp, value| disp}).first}"
    else
      a=nil
    end
    a
  end

  def display_intake
    if intake_id.blank?
      "#{intake.to_date.strftime("%b %Y") }"
    else
      intakestudent.monthyear_intake.strftime('%b %Y')
    end
  end
  
  def display_intake_amsas
    if intake_id.blank?
      "#{intake.to_date.strftime("%b %Y") }"
    else
     "Siri #{intakestudent.monthyear_intake.strftime('%m/%Y')}"
    end
  end

  def display_regdate
    #"#{regdate.to_date.strftime("%d-%m-%Y") unless regdate.nil?}"
    unless regdate.blank?
      a=regdate.to_date.strftime("%d-%m-%Y") 
    else
      a="\'\'"
    end
  end
  def display_gender
   "#{((Student::GENDER.find_all{|disp, value| value == gender.to_s}).map {|disp, value| disp}).first}"
  end

  def display_enddate
    #"#{end_training.to_date.strftime("%d-%m-%Y") unless end_training.nil?}"
    unless end_training.blank?
      end_training.to_date.strftime("%d-%m-%Y") 
    else
      "\'\'"
    end
  end

  def display_birthdate
    unless sbirthdt.blank?
      "#{sbirthdt.to_date.strftime("%d-%m-%Y") unless sbirthdt.nil?}"
    else
      "\'\'"
    end
  end
 
  def display_bloodtype
    if bloodtype.nil? || bloodtype.blank?
      a=nil
    else
      a="#{((Student::BLOOD_TYPE.find_all{|disp, value| value == bloodtype.to_s}).map {|disp, value| disp}).first}"
    end
    a
  end

  def display_address
    if address.nil? || address.blank?
      a=nil
    else
      a="#{address.gsub!(/\s/," ")}"
    end
    a
  end
  def display_marital
    unless mrtlstatuscd.blank?
      "#{((Student::MARITAL_STATUS.find_all{|disp, value| value == mrtlstatuscd.to_s}).map {|disp, value| disp}).first}"
    else
      "\'\'"
    end
  end
  
  def display_stelno
    unless stelno.nil?
      a= "\'"+stelno+"\'"
    else
      nil
    end
  end
  
  def display_status
    #"#{((Student::STATUS.find_all{|disp, value| value==sstatus}).map {|disp, value| disp}).first}"
    unless sstatus.blank?
      if college_id==College.where(code: 'amsas').first.id
        a="#{((Student::STATUS_AMSAS.find_all{|disp, value| value==sstatus}).map {|disp, value| disp}).first}"
      else
        a="#{((Student::STATUS.find_all{|disp, value| value==sstatus}).map {|disp, value| disp}).first}"
      end
    else
      a="\'\'"
    end
  end
  def display_sstatus_remark
    if sstatus == "Repeat"
      unless sstatus_remark.blank?
        a="#{I18n.t('student.students.semester_repeated')+": "+ sstatus_remark}"
      else
        a="\'\'"
      end
    else
      unless sstatus_remark.blank? 
        a="#{sstatus_remark}"
      else
        a="\'\'"
      end
    end
    a
  end
  def display_programme
    unless course_id.nil?
      a=course.try(:programme_list)
    else
      a=nil
    end
    a
  end
  def display_physical
    unless physical.blank?
      a="#{physical}"
    else
      a=nil
    end
    a
  end
  def display_allergy
    unless allergy.blank?
      a="#{allergy}"
    else
      a=nil
    end
    a
  end
  def display_disease
    unless disease.blank?
      a="#{disease}"
    else
      a=nil
    end
    a
  end
  def display_offer_letter
    unless offer_letter_serial.blank?
      a="#{offer_letter_serial.to_s}"
    else
      a=nil
    end
    a
  end
  def display_semail
    unless semail.blank?
      a="#{semail}"
    else
      a=nil
    end
    a
  end
  def display_medication
    unless medication.blank?
      a="#{medication}"
    else
      a=nil
    end
    a
  end
  def display_medicalremarks
    unless remarks.blank?
      a="#{remarks}"
    else
      a=nil
    end
    a
  end
  def display_courseremarks
    if course_remarks.blank? || course_remarks.nil?
      a=nil
    else
      a="#{course_remarks}"
    end
    a
  end
  #for Export Excel -- end

  #for Import Excel -- start
  def self.update_student(spreadsheet)
    spreadsheet.default_sheet = spreadsheet.sheets.first 
    header = spreadsheet.row(1)
    
    student_status=[]
    Student::STATUS_COMBINE.each do |name, saved_status|
      student_status << saved_status
    end
    
    student_sponsor=[]
    Student::SPONSOR.each do |name, saved_sponsor|
      student_sponsor << saved_sponsor
    end
    
    student_course=[]
    Programme.roots.sort.each do |course|
      student_course << course.id
    end
    
    student_marital=[]
    Student::MARITAL_STATUS.each do |name, saved_marital|
      student_marital << saved_marital
    end
    
    student_race=[]
    Student::RACE.each do |name, saved_race|
      student_race << saved_race
    end
    
    student_birthplace=[]
    Student::STATECD.each{|n, sb| student_birthplace << sb}
      
    student_religion=[]
    Student::RELIGION.each{|n, sb| student_religion << sb}
    
    student_intake=Intake.pluck(:id)
    
    saved_students=[]
    icno_not_exist=[]
    name_not_exist=[]
    stelno_not_exist=[]
    status_not_valid=[]
    sponsor_not_valid=[]
    gender_not_valid=[]
    course_id_not_valid=[]
    college_id_not_valid=[]
    sbirthdt_not_valid=[]
    intake_not_valid=[]
    marital_not_valid=[]
    #race_not_valid=[] - not compulsory
    
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose] 

      #retrieve UNIQUE fields of icno
      #additional Float check required for numbers-only data
      #lstrip required for string to remove leading/preceeding spaces
      icno_e=row["icno"] 
      if icno_e.is_a? Numeric
        icno_e=icno_e.to_i.to_s #if icno_e.to_i.to_s.size==12 #- temporary remark for as armed force no size is differ
      elsif icno_e.is_a? String
        icno_e=icno_e.lstrip #if icno_e.lstrip.size==12 #- temporary remark for as armed force no size is differ
      else
       #cell is blank? 
        icno_not_exist << i
        icno_e = nil
      end
      
      name_e=row["name"]
      if name_e.is_a? String
        if name_e.lstrip.size>0
          name_e=name_e.lstrip
        else
          name_not_exist << i
          name_e=nil
        end
      else
        name_not_exist << i
        name_e=nil
      end 
      
      stelno_e=row["stelno"] 
      if stelno_e.is_a? Numeric
        stelno_e= stmrtlstatuscd_e=mrtlstatuscd_e.to_selno_e.to_i.to_s
      elsif stelno_e.is_a? String
	 if stelno_e.lstrip.size>0
          stelno_e=stelno_e.lstrip
        else
          stelno_not_exist << i
          stelno_e=nil
        end
      else
        stelno_not_exist << i
	stelno_e=nil
      end
      
      sstatus_e=row["sstatus"]
      if sstatus_e.is_a? String
        sstatus_e=sstatus_e.titleize
        if student_status.include?(sstatus_e)
          sstatus_e = sstatus_e
        else
          status_not_valid << i
          sstatus_e=nil
        end
      else
        #wrong data ignored - string required
        sstatus_e=nil
        status_not_valid << i
      end
      
      ssponsor_e=row["ssponsor"]
      if ssponsor_e.is_a? String
        if student_sponsor.include?(ssponsor_e)
          ssponsor_e = ssponsor_e
        else
          sponsor_not_valid << i
          ssponsor_e=nil
        end
      else
        #wrong data ignored - string required
        ssponsor_e=nil
        sponsor_not_valid << i
      end
      
      gender_e=row["gender"]   
      if gender_e.is_a? Numeric
         gender_e=gender_e.to_i
      elsif gender_e.is_a? String
        gender_e=gender_e.lstrip if gender_e
        if LibraryHelper.all_digits(gender_e) && [1,2].include?(gender_e.to_i)
          gender_e=gender_e.to_i
        else
          #wrong data ignored - number required
          gender_e=nil
          gender_not_valid << i
        end
      end
      
      course_id_e=row["course_id"]
      if course_id_e.is_a? String 
        if LibraryHelper.all_digits(course_id_e) && student_course.include?(course_id_e.to_i)
          course_id_e=course_id_e.to_i
        else
          #wrong data ignored - number required
          course_id_e=nil
          course_id_not_valid << i
        end
      else
        if student_course.include?(course_id_e)
          course_id_e=course_id_e.to_i 
        else
          course_id_e=nil
          course_id_not_valid << i
        end
      end
      
      race2_e=row["race2"]
      if race2_e.is_a? String 
        if LibraryHelper.all_digits(race2_e) && student_race.include?(race2_e.to_i)
          race2_e=race2_e.to_i
        else
          #wrong data ignored - number required
          race2_e=nil
          #race_not_valid << i
        end
      else
        if student_race.include?(race2_e.to_i)
          race2_e=race2_e.to_i 
        else
          race2_e=nil
          #race_not_valid << i
        end
      end
      
      ## TODO - Check will error arise at line 405 for KSKBJB (KSKBJB: non-mandatory, AMSAS: mandatory) : birthplace_e=row["birthplace"] & line 423 : religion_e=row["religion"]
      birthplace_e=row["birthplace"]
      if birthplace_e.is_a? String 
        if LibraryHelper.all_digits(birthplace_e) && student_birthplace.include?(birthplace_e.to_i)
          birthplace_e=birthplace_e.to_i
        else
          #wrong data ignored - number required
          birthplace_e=nil
          #race_not_valid << i
        end
      else
        if student_birthplace.include?(birthplace_e.to_i)
          birthplace_e=birthplace_e.to_i 
        else
          birthplace_e=nil
          #race_not_valid << i
        end
      end
      
      religion_e=row["religion"]
      if religion_e.is_a? String 
        if LibraryHelper.all_digits(religion_e) && student_religion.include?(religion_e.to_i)
          religion_e=religion_e.to_i
        else
          #wrong data ignored - number required
          religion_e=nil
          #race_not_valid << i
        end
      else
        if student_religion.include?(religion_e.to_i)
          religion_e=religion_e.to_i 
        else
          religion_e=nil
          #race_not_valid << i
        end
      end
      ##
      
      mrtlstatuscd_e=row["mrtlstatuscd"]
      if mrtlstatuscd_e.is_a? String 
        if LibraryHelper.all_digits(mrtlstatuscd_e) && student_marital.include?(mrtlstatuscd_e)
          #mrtlstatuscd_e=mrtlstatuscd_e.to_s
        else
          #wrong data ignored - number required
          mrtlstatuscd_e=nil
          marital_not_valid << i
        end
      else
        if student_marital.include?(mrtlstatuscd_e.to_i.to_s)
          mrtlstatuscd_e=mrtlstatuscd_e.to_i.to_s
        else
          mrtlstatuscd_e=nil
          marital_not_valid << i
        end
      end

      sbirthdt_e=row["sbirthdt"]
      unless sbirthdt_e.nil? || sbirthdt_e.blank? || sbirthdt_e==""
        if sbirthdt_e.is_a? Date
        else
           if sbirthdt_e.size==10
             sbirthdt_e=sbirthdt_e.to_date
           else
             sbirthdt_e=nil
             sbirthdt_not_valid << i
           end
        end
      else
        sbirthdt_e=nil
        sbirthdt_not_valid << i
      end
      
#       intake_e=row["intake"]
#       unless intake_e.nil? || intake_e.blank? || intake_e==""
#         if intake_e.is_a? Date
#         else
#            if intake_e.size==10
#              intake_e=intake_e.to_date
#            else
#              intake_e=nil
#              intake_not_valid << i
#            end
#         end
#       else
#         intake_e=nil
#         intake_not_valid << i
#       end
      
      intake_e=row["intake_id"]
      if intake_e.is_a? String 
        if LibraryHelper.all_digits(intake_e) && student_intake.include?(intake_e.to_i)
          intake_id_e=intake_id_e.to_i
        else
          #wrong data ignored - number required
          intake_e=nil
          intake_not_valid << i
        end
      else
        if student_intake.include?(intake_e)
          intake_e=intake_e.to_i
        else
          intake_e=nil
          intake_not_valid << i
        end
      end
      
      college_id_e=row["college_id"]
      if college_id_e.is_a? String 
        if LibraryHelper.all_digits(college_id_e) && student_course.include?(college_id_e.to_i)
          college_id_e=college_id_e.to_i
        else
          #wrong data ignored - number required
          college_id_e=nil
          college_id_not_valid << i
        end
      else
        if student_course.include?(college_id_e)
          college_id_e=college_id_e.to_i 
        else
          college_id_e=nil
          college_id_not_valid << i
        end
      end
      
      ##validates_presence_of     :icno, :name, :sstatus, :stelno, :ssponsor, :sbirthdt,     :gender, :mrtlstatuscd, :intake,:course_id
      
      #based on above UNIQUE fields, retrieve existing record(s) Or create new
      student_recs = Student.where(icno: icno_e)
      student_rec = student_recs.first || Student.new

      #columns in excel - icno, name, stelno, sstatus, ssponsor, sbirthdt, gender, mrtlstatuscd, course_id & intake MUST EXIST
      if icno_e && name_e && stelno_e && sstatus_e && ssponsor_e && sbirthdt_e && gender_e && mrtlstatuscd_e && course_id_e && intake_e  && college_id_e ##&& race2_e
        student_rec.icno = icno_e
        student_rec.name = name_e
        student_rec.stelno = stelno_e
        student_rec.gender = gender_e
        student_rec.course_id = course_id_e
        student_rec.college_id = college_id_e
        student_rec.race2 = race2_e
        student_rec.mrtlstatuscd = mrtlstatuscd_e
        student_rec.sstatus = sstatus_e
        student_rec.ssponsor = ssponsor_e
        student_rec.sbirthdt = sbirthdt_e 
        student_rec.intake = intake_e
	student_rec.birthplace=birthplace_e #required for Amsas
	student_rec.religion=religion_e #required for Amsas
	student_rec.intake_id=intake_e
	student_rec.intake=''
        student_rec.attributes = row.to_hash.slice("matrixno","sstatus_remark", "semail", "regdate", "offer_letter_serial", "end_training", "address", "address_posbasik")
        student_rec.save!
        #saved_students << student_rec if !student_rec.id.nil?
        saved_students << i #if !student_rec.id.nil?
      end
    end
    result={:svs=>saved_students, :ine=> icno_not_exist, :stnv=>status_not_valid, :spnv=>sponsor_not_valid, :nne => name_not_exist, :stne =>stelno_not_exist, :sbnv => sbirthdt_not_valid, :gnv =>gender_not_valid, :mnv=>marital_not_valid, :cinv=>course_id_not_valid, :inv =>intake_not_valid, :colnv => college_id_not_valid} 
  end
  
  def self.msg_import(a) 
    if a[:svs].count>0
      lines=''
      a[:svs].each_with_index do |l,no|
        lines+=l.to_s
        lines+=", " if no < (a[:svs].count)-1
      end
      msg=a[:svs].count.to_s+(I18n.t 'actions.records')+(I18n.t 'actions.imported_updated')+(I18n.t 'actions.line_no_excel')+lines+")"
    end
    msg 
  end 

  def self.msg_import2(a) 
    msg=""
    if a[:ine].count>0
      lines2=''
      a[:ine].each_with_index do |l,no|
        lines2+=l.to_s
        lines2+=", " if no < (a[:ine].count)-1
      end
      msg+=a[:ine].count.to_s+(I18n.t 'student.students.icno_invalid')+(I18n.t 'actions.line_no_excel')+lines2+")"
    end
    
    if a[:ine].count>0 && a[:nne].count>0
      msg+=", "
    end
    if a[:nne].count>0
      lines5=''
      a[:nne].each_with_index do |l,no|
        lines5+=l.to_s
        lines5+=", " if no < (a[:nne].count)-1
      end
      msg+=a[:nne].count.to_s+(I18n.t 'student.students.name_invalid')+(I18n.t 'actions.line_no_excel')+lines5+")"
    end
  
    if (a[:ine].count>0 || a[:nne].count>0) && a[:stne].count>0
      msg+=", "
    end
    if a[:stne].count>0
      lines6=''
      a[:stne].each_with_index do |l,no|
        lines6+=l.to_s
        lines6+=", " if no < (a[:stne].count)-1
      end
      msg+=a[:stne].count.to_s+(I18n.t 'student.students.stelno_invalid')+(I18n.t 'actions.line_no_excel')+lines6+")"
    end
    
    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0) && a[:stnv].count>0
      msg+=", "
    end
    if a[:stnv].count>0
      lines3=''
      a[:stnv].each_with_index do |l,no|
        lines3+=l.to_s
        lines3+=", " if no < (a[:stnv].count)-1
      end
      msg+=a[:stnv].count.to_s+(I18n.t 'student.students.sstatus_invalid')+(I18n.t 'actions.line_no_excel')+lines3+")"
    end
    
    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0 || a[:stnv].count>0) && a[:spnv].count>0
      msg+=", "
    end
    if a[:spnv].count>0
      lines4=''
      a[:spnv].each_with_index do |l,no|
        lines4+=l.to_s
        lines4+=", " if no < (a[:spnv].count)-1
      end
      msg+=a[:spnv].count.to_s+(I18n.t 'student.students.ssponsor_invalid')+(I18n.t 'actions.line_no_excel')+lines4+")"
    end
    
    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0 || a[:stnv].count>0 || a[:spnv].count>0) && a[:sbnv].count>0
      msg+=", "
    end
    if a[:sbnv].count>0
      lines7=''
      a[:sbnv].each_with_index do |l,no|
        lines7+=l.to_s
        lines7+=", " if no < (a[:sbnv].count)-1
      end
      msg+=a[:sbnv].count.to_s+(I18n.t 'student.students.sbirthdt_invalid')+(I18n.t 'actions.line_no_excel')+lines7+")"
    end
    
    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0 || a[:stnv].count>0 || a[:spnv].count>0 ||  a[:sbnv].count>0) && a[:gnv].count>0
      msg+=", "
    end
    if a[:gnv].count>0
      lines8=''
      a[:gnv].each_with_index do |l,no|
        lines8+=l.to_s
        lines8+=", " if no < (a[:gnv].count)-1
      end
      msg+=a[:gnv].count.to_s+(I18n.t 'student.students.gender_invalid')+(I18n.t 'actions.line_no_excel')+lines8+")"
    end
    
    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0 || a[:stnv].count>0 || a[:spnv].count>0 ||  a[:sbnv].count>0 || a[:gnv].count>0) && a[:mnv].count>0
      msg+=", "
    end
    if a[:mnv].count>0
      lines9=''
      a[:mnv].each_with_index do |l,no|
        lines9+=l.to_s
        lines9+=", " if no < (a[:mnv].count)-1
      end
      msg+=a[:mnv].count.to_s+(I18n.t 'student.students.marital_invalid')+(I18n.t 'actions.line_no_excel')+lines9+")"
    end

    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0 || a[:stnv].count>0 || a[:spnv].count>0 ||  a[:sbnv].count>0 || a[:gnv].count>0 || a[:mnv].count>0) && a[:cinv].count>0
      msg+=", "
    end
    if a[:cinv].count>0
      lines10=''
      a[:cinv].each_with_index do |l,no|
        lines10+=l.to_s
        lines10+=", " if no < (a[:cinv].count)-1
      end
      msg+=a[:cinv].count.to_s+(I18n.t 'student.students.course_id_invalid')+(I18n.t 'actions.line_no_excel')+lines10+")"
    end    
    
    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0 || a[:stnv].count>0 || a[:spnv].count>0 ||  a[:sbnv].count>0 || a[:gnv].count>0 || a[:mnv].count>0|| a[:cinv].count>0) && a[:inv].count>0
      msg+=", "
    end
    if a[:inv].count>0
      lines11=''
      a[:inv].each_with_index do |l,no|
        lines11+=l.to_s
        lines11+=", " if no < (a[:inv].count)-1
      end
      msg+=a[:inv].count.to_s+(I18n.t 'student.students.intake_invalid')+(I18n.t 'actions.line_no_excel')+lines11+")"
    end   
    ##
    if (a[:ine].count>0 || a[:nne].count>0 || a[:stne].count>0 || a[:stnv].count>0 || a[:spnv].count>0 ||  a[:sbnv].count>0 || a[:gnv].count>0 || a[:mnv].count>0|| a[:cinv].count>0 || a[:inv].count>0)  && a[:colnv].count > 0
      msg+=", "
    end
    if a[:colnv].count>0
      lines12=''
      a[:colnv].each_with_index do |l,no|
        lines12+=l.to_s
        lines12+=", " if no < (a[:colnv].count)-1
      end
      msg+=a[:colnv].count.to_s+(I18n.t 'student.students.college_invalid')+(I18n.t 'actions.line_no_excel')+lines12+")"
    end 
    ##
    msg
  end
  #for Import Excel -- end
  
end