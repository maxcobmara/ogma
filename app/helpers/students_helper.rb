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
   unless matrixno.nil?
     a="#{matrixno}"
   else
     nil
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
   "#{intake.to_date.strftime("%b %Y") }"
 end

 def display_regdate
   "#{regdate.to_date.strftime("%d-%m-%Y") unless regdate.nil?}"
 end
 def display_gender
  "#{((Student::GENDER.find_all{|disp, value| value == gender.to_s}).map {|disp, value| disp}).first}"
 end

 def display_enddate
   "#{end_training.to_date.strftime("%d-%m-%Y") unless end_training.nil?}"
 end

 def display_birthdate
   "#{sbirthdt.to_date.strftime("%d-%m-%Y") unless sbirthdt.nil?}"
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
   "#{((Student::MARITAL_STATUS.find_all{|disp, value| value == mrtlstatuscd.to_s}).map {|disp, value| disp}).first}"
 end
 def display_status
   "#{((Student::STATUS.find_all{|disp, value| value==sstatus}).map {|disp, value| disp}).first}"
 end
 def display_sstatus_remark
   if sstatus == "Repeat"
     unless sstatus_remark.nil?
       a="#{I18n.t('student.students.semester_repeated')+": "+ sstatus_remark}"
     else
       a=nil
     end
   else
     unless sstatus_remark.nil? 
       a="#{sstatus_remark}"
     else
       a=nil
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

end