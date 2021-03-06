class Weeklytimetable < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  
  #before_save :set_semester
  before_save :set_to_nil_where_false, :intake_must_match_with_programme
  before_save :manual_remove_details_if_marked, prepend: true
  
  belongs_to :schedule_programme, :class_name => 'Programme',       :foreign_key => 'programme_id'
  #belongs_to :schedule_semester,  :class_name => 'Programme',       :foreign_key => 'semester'
  belongs_to :schedule_intake,    :class_name => 'Intake',          :foreign_key => 'intake_id' 
  belongs_to :schedule_creator,   :class_name => 'Staff',           :foreign_key => 'prepared_by'
  belongs_to :schedule_approver,  :class_name => 'Staff',           :foreign_key => 'endorsed_by'
  belongs_to :timetable_monthurs, :class_name => 'Timetable',       :foreign_key => 'format1'
  belongs_to :timetable_friday,   :class_name => 'Timetable',       :foreign_key => 'format2'
  belongs_to :academic_semester,  :class_name => 'AcademicSession', :foreign_key => 'semester'
  
  has_many :weeklytimetable_details, :dependent => :destroy
  accepts_nested_attributes_for :weeklytimetable_details, :reject_if => proc {|a|a['topic'].blank? || a['lecturer_id'].blank? || a['lecture_method'].blank?} 

  #validates_presence_of :programme_id, :semester, :intake_id, :format1, :format2
  validates_presence_of :programme_id, :intake_id, :startdate, :enddate, :week, :prepared_by, :semester, :format1, :format2
  validate :approved_or_rejected, :restrict_lecturer_per_class_duration
  validates_presence_of :hod_approved_on, :if => :hod_approval?
  validates_presence_of :hod_rejected_on, :reason, :if => :hod_rejection?
  
  attr_accessor :set_error_slot
  #attr_accessor :subject_id  #for testing grouped programme (subject)
  
  #before logic
  def set_to_nil_where_false
    if is_submitted == true
      self.submitted_on= Date.today
    end
    if is_submitted == true && hod_approved_on==nil && hod_approved==nil 
       self.hod_rejected = nil 
    end
    if hod_rejected == true && reason!="" && hod_approved==false
      self.is_submitted = nil
      self.hod_approved_on =nil
      self.hod_approved=nil
    end
    if hod_approved==true 
      self.reason=nil
    end
  end
  
  def hod_approval?
    hod_approved==true && hod_rejected==false
  end
  
  def hod_rejection?
    hod_rejected==true && hod_approved==false
  end
  
  def manual_remove_details_if_marked
    weeklytimetable_details.each do |wd|
      unless (wd.id.nil? || wd.id.blank?)
        if wd.subject==1 || wd.subject=="1"
          db_wd = Weeklytimetable.find(id).weeklytimetable_details.where('id=?',wd.id)[0]
          db_wd.destroy
        end
      end
    end
  end
  
  #define scope
  def self.schedule_creator_search(query)
    staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    where('prepared_by IN(?)', staff_ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:schedule_creator_search]
  end

  def restrict_lecturer_per_class_duration #------
    count_errors=0
    count_marked2=0
    current_date_period=[]
    current_date_period2=[]
    details_by_lecturer = Hash.new
    current_wd=[]
    new_lecturer=[]
    
    #to exclude currently EDIT one (saved records)
    current_wd=weeklytimetable_details.pluck(:id)
    
    #but include only current lecturers (saved records)
    current_lecturer=weeklytimetable_details.pluck(:lecturer_id) 

    #test grab lecturers of NEW 'weeklytimetable_details' (not yet saved) & re-selected lecturer of EXISTING 'weeklytimetable_details'
    weeklytimetable_details.each do |wd|
      if (wd.id.nil? || wd.id.blank?)
        new_lecturer<< wd.lecturer_id
      else
        new_lecturer<< wd.lecturer_id
      end
    end
       
    if current_lecturer.count==0
      current_lecturer = new_lecturer
    elsif current_lecturer.count!=0
      current_lecturer+=new_lecturer
    end
 
    #Start - EXISTING record excluding Currently EDIT
    if current_wd!=[]
      details_g_lecturer = WeeklytimetableDetail.where('id NOT IN(?) and lecturer_id IN(?)',current_wd,current_lecturer.uniq).group_by(&:lecturer_id)   
    else
      details_g_lecturer = WeeklytimetableDetail.where('lecturer_id IN(?)',current_lecturer.uniq).group_by(&:lecturer_id)
    end
    
    details_g_lecturer.each do |lecturer, details|        
      details.each do |x|
        wt = x.weeklytimetable_id
        sdate=x.weeklytimetable.startdate
        tp_1 = Weeklytimetable.where(id: wt).first.format1
        tp_2 = Weeklytimetable.where(id: wt).first.format2   #Thurs/Firday
        if x.is_friday == true
          current_date = (sdate+4).try(:strftime, "%d%b%Y")
#           period_start = TimetablePeriod.where(id:x.time_slot)[0].start_at
#           period_end = TimetablePeriod.where(id:x.time_slot)[0].end_at
	  period_start = TimetablePeriod.where(timetable_id: tp_2, sequence: x.time_slot)[0].start_at
          period_end = TimetablePeriod.where(timetable_id: tp_2, sequence: x.time_slot)[0].end_at
          period = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          unless x.subject.nil? || x.subject.blank?
            current_date_period << current_date +" "+ period+" "+x.subject.to_s+" "+lecturer.to_s#+" "+x.id.to_s
            #current_date_period2 << current_date +" "+ period+" "+x.subject.to_s+" "+lecturer.to_s+" "+x.id.to_s   ******-unremark for checking 2Jul2015
          else
            current_date_period << current_date +" "+ period+" "+"0"+" "+lecturer.to_s#+" "+x.id.to_s
            #current_date_period2 << current_date +" "+ period+" "+x.subject.to_s+" "+lecturer.to_s+" "+x.id.to_s  ******-unremark for checking 2Jul2015
          end
        else
          current_date2 = sdate.try(:strftime, "%d%b%Y") if x.day2==1        #weekdays
          current_date2 = (sdate+1).try(:strftime, "%d%b%Y") if x.day2==2    
          current_date2 = (sdate+2).try(:strftime, "%d%b%Y") if x.day2==3
          current_date2 = (sdate+3).try(:strftime, "%d%b%Y") if x.day2==4
          current_date2 = (sdate+5).try(:strftime, "%d%b%Y") if x.day2==6    #weekends
          current_date2 = (sdate+6).try(:strftime, "%d%b%Y") if x.day2==7  
          period_start = TimetablePeriod.where(timetable_id: tp_1, sequence: x.time_slot2)[0].start_at
          period_end = TimetablePeriod.where(timetable_id: tp_1, sequence: x.time_slot2)[0].end_at
          period2 = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          unless x.subject.nil? || x.subject.blank?
            current_date_period << current_date2 +" "+ period2+" "+x.subject.to_s+" "+lecturer.to_s#+" "+x.id.to_s
            #current_date_period2 << current_date2 +" "+ period2+" "+x.subject.to_s+" "+lecturer.to_s+" "+x.id.to_s  ******-unremark for checking 2Jul2015
          else
            current_date_period << current_date2 +" "+ period2+" "+"0"+" "+lecturer.to_s#+" "+x.id.to_s
            #current_date_period2 << current_date2 +" "+ period2+" "+"0"+" "+lecturer.to_s+" "+x.id.to_s    ******-unremark for checking 2Jul2015
          end
        end        
      end
      #details_by_lecturer[lecturer]=current_date_period
    end
    #End - EXISTING record excluding Currently EDIT
    
    @all_error_slots=[]    
        
    #START - Currently EDIT (EXIST - currently EDIT(saved one) & totally NEW)
    details2 = weeklytimetable_details.group_by(&:lecturer_id)    
    details2.each do |l,d2|
      d2.each do |y|
        wt = y.weeklytimetable_id
        tp_1 = Weeklytimetable.where(id: wt).first.format1
        tp_2 = Weeklytimetable.where(id: wt).first.format2    #Thurs/Firday
        if y.is_friday == true
          current_date = (startdate+4).try(:strftime,"%d%b%Y")
          period_start = TimetablePeriod.where(timetable_id: tp_2, sequence: y.time_slot)[0].start_at 
          period_end = TimetablePeriod.where(timetable_id: tp_2, sequence: y.time_slot)[0].end_at
          period = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          unless y.subject.nil? || y.subject.blank?
            current_date_period << current_date +" "+ period+" "+y.subject.to_s+" "+l.to_s#+" "+y.id.to_s
            #current_date_period2 << current_date +" "+ period+" "+y.subject.to_s+" "+l.to_s+" "+y.id.to_s+"salah baca masa 3"  ******-unremark for checking 2Jul2015
          else
            current_date_period << current_date +" "+ period+" "+"0"+" "+l.to_s#+" "+y.id.to_s
           # current_date_period2 << current_date +" "+ period+" "+"0"+" "+l.to_s+" "+y.id.to_s+"salah baca masa 3 -->"+y.time_slot.to_s  ******-unremark for 2Jul2015 checking
          end
        else
          current_date2 = startdate.try(:strftime, "%d%b%Y") if y.day2==1    #weekdays
          current_date2 = (startdate+1).try(:strftime, "%d%b%Y") if y.day2==2    
          current_date2 = (startdate+2).try(:strftime, "%d%b%Y") if y.day2==3
          current_date2 = (startdate+3).try(:strftime, "%d%b%Y") if y.day2==4
          current_date2 = (startdate+5).try(:strftime, "%d%b%Y") if y.day2==6    #weekends
          current_date2 = (startdate+6).try(:strftime, "%d%b%Y") if y.day2==7 
          period_start = TimetablePeriod.where(timetable_id: tp_1, sequence: y.time_slot2)[0].start_at
          period_end = TimetablePeriod.where(timetable_id: tp_1, sequence: y.time_slot2)[0].end_at
          period2 = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          unless y.subject.nil? || y.subject.blank?
            current_date_period << current_date2 +" "+ period2+" "+y.subject.to_s+" "+l.to_s#+" "+y.id.to_s    
            #current_date_period2 << current_date2 +" "+ period2+" "+y.subject.to_s+" "+l.to_s+" "+y.id.to_s+"salah baca masa"  ******-unremark for checking 2Jul2015
          else
            current_date_period << current_date2 +" "+ period2+" "+"0"+" "+l.to_s#+" "+y.id.to_s    
            #current_date_period2 << current_date2 +" "+ period2+" "+"0"+" "+l.to_s+" "+y.id.to_s+"salah baca masa2"   ******-unremark for checking 2Jul2015
          end
        end
      end
    end 
    
    #NOTE : current_date_period - includes EXISTING & NEW
    
    error_slots=[]
    #-start-this part is to avoid system from taking incomplete 'current_date_period' (subject NOT exist) into account
    cdp=[]
    current_date_period.each do |j|
      splitter3 = j.split(" ")
      #NEW record (weeklytimetable_detail) - ALL NEW record (weeklytimetable_detail) won't be saved (including redundant one) unless...
      if splitter3.count==3 #'removed?'(subject field) NOT EXIST for new records (==id.nil?||==id.blank?)
        cdp<< ([splitter3[0]]+[splitter3[1]]+["0"]+[splitter3[2]]).join(" ")
      else
        cdp<< j
      end
    end
    #-end-this part is to avoid system from taking incomplete 'current_date_period' (subject NOT exist) into account
    
    #(A) Works for both if:(1)Existing WD (already redundant) & (2)New WD (will be redundant) ...OR... ONLY if (1)Existing WD (already redundant)  
    if current_date_period.length != current_date_period.uniq.length 
      count_marked=0 
              
      duplicate_cdp = cdp.find_all {|e|cdp.count(e)>1}
      duplicate_cdp.uniq.each do |i|
        item_count=0
        count_e=0
        splitter1 = i.split(" ")
        duplicate_cdp.each do |xy|           
          splitter2 = xy.split(" ")     
          if splitter2[0]+splitter2[1]==splitter1[0]+splitter1[1]
            item_count+=1
            if (splitter2[2]==0 || splitter2[2]=="0")   #not marked for removal 
              count_e+=1
              if item_count>=2 && count_e>=2
                error_slots<< splitter2[0]+" "+splitter2[1]#+item_count.to_s+count_e.to_s+"yoyo"  ******-unremark for checking 2Jul2015
              end
            elsif splitter2[2]==1 || splitter2[2]=="1"  #marked for removal
              #count_marked+=1
            end 
          end
        end
      end     
      #if count_marked>0
        #count_marked2+=1
      #end  
      
    #(B):(2)Works ONLY if New WD (will be redundant) 
    else  

      item_count=0
      count_e=0
      
      duplicate_cdp = cdp.find_all {|e|cdp.count(e)>1}
      duplicate_cdp.uniq.each do |i|
        item_count=0
        count_e=0
        splitter1 = i.split(" ")
        duplicate_cdp.each do |xy|           
          splitter2 = xy.split(" ")     
          if splitter2[0]+splitter2[1]==splitter1[0]+splitter1[1]
            item_count+=1
            if (splitter2[2]==0 || splitter2[2]=="0")   #not marked for removal 
              count_e+=1
              if item_count>=2 && count_e>=2
                error_slots<< splitter2[0]+" "+splitter2[1]#+item_count.to_s+count_e.to_s+"yaya"   ******-unremark for checking 2Jul2015
              end
            elsif splitter2[2]==1 || splitter2[2]=="1"  #marked for removal
              #count_marked+=1
            end 
          end
        end
      end
      #if count_marked>0
        #count_marked2+=1
      #end
      
    end

    count_errors+=error_slots.count
    error_slots.each do |es|
      @all_error_slots<< es#+"yiyi"
    end
    error_lines=""
    @all_error_slots.each_with_index do |error_line,ind|
      el = error_line.split(" ")
      rev_el_1=(el[1].split("-")[0].to_time.strftime("%l:%M:%P"))+" - "+(el[1].split("-")[1].to_time.strftime("%l:%M:%P"))+"  "
      error_lines+= "("+(ind+1).to_s+") "+I18n.t('training.weeklytimetable.date_time')+el[0]+" "+rev_el_1
    end
    #END - Currently EDIT
    
    if count_errors>0       
      errors.add(:base, I18n.t('training.weeklytimetable.duplicate_lecturer')+" #{error_lines}") #+"~ #{current_date_period2} #{@all_error_slots.uniq.count}")   ****** remove last right bracket ')' & unremark for checking (current_date_period2 will display all existing time slot) 2Jul2015
      #*******
      #errors.add(:base, "#{count_marked2} #{count_errors} #{details2.count} #{details_g_lecturer.count}-#{current_date_period}+#{current_date_period.uniq} * #{current_lecturer} ==#{new_lecturer} ~~#{current_wd} ` #{current_date_period.count}==`#{current_date_period.uniq.count}--->#{@all_error_slots}")
      self.set_error_slot = @all_error_slots.uniq
    end
  end#------

  #dip & posbasiks
  def self.search2(programmeid, roles, staffid)  
    intake_of_coordinator=Intake.where(programme_id: programmeid, staff_id: staffid)
    intake_ids=intake_of_coordinator.pluck(:id) if intake_of_coordinator.count > 0
#     main_task_first=Position.where(staff_id: staffid).first.tasks_main
#     if main_task_first.include?("Penyelaras Kumpulan")
#       a=main_task_first.scan(/Penyelaras Kumpulan (.*)/)[0][0].strip 
#       if a.include?(" ")  #space exist, others may exist too
#         a_rev=a.gsub!(/[^a-zA-Z]/," ")   #in case a consist of comma, etc 
#         intake_desc=a_rev.split(" ")[0] #intake_desc=group
#       else
#         intake_desc=a 
#       end
#       intakeid=Intake.where(programme_id: programmeid, description: intake_desc).first.id
#     end
    if roles.include?("programme_manager") || roles.include?("coordinator") || roles.include?("weeklytimetables_module_member")#coordinator here - w/o group name/no  may see all
      weeklytimetables= Weeklytimetable.where(programme_id: programmeid)
#     elsif main_task_first.include?("Penyelaras Kumpulan") && intakeid
#       #weeklytimetables= Weeklytimetable.where(programme_id: programmeid, intake_id: intakeid) - betulnye, suppose must assign Penyelaras Kumpulan XXXX
#        weeklytimetables= Weeklytimetable.where('programme_id=? and (intake_id=? or prepared_by=?)',  programmeid,  intakeid, staffid) #retrieve : prev working sample
    elsif intake_ids
      weeklytimetables=Weeklytimetable.where('programme_id=? and (intake_id IN(?) or prepared_by=?)', programmeid, intake_ids, staffid)
    else
      weeklytimetables= Weeklytimetable.where(programme_id: programmeid, prepared_by: staffid) #include prev coordinator
    end
  end
  
  #common subjects
#   def self.search3(subject_name, main_task_first, staffid) 
#     if main_task_first.include?("Ketua Subjek")
#       csubjects_post_lect_ids=Position.where(unit: subject_name).pluck(:staff_id).compact
#       wt_ids=WeeklytimetableDetail.where(lecturer_id: csubjects_post_lect_ids).pluck(:weeklytimetable_id)
#       weeklytimetables = Weeklytimetable.where(id: wt_ids)
#     else
#       wt_ids=WeeklytimetableDetail.where(lecturer_id: staffid).pluck(:weeklytimetable_id)
#       weeklytimetables = Weeklytimetable.where(id: wt_ids) #impossible for common subject lecturer to become preparer
#     end
#   end

  def main_details_for_weekly_timetable
    "#{schedule_programme.programme_list}"+" Intake : "+"#{schedule_intake.name}" +" - (Week : "+"#{startdate.strftime('%d-%m-%Y')}"+" - "+"#{enddate.strftime('%d-%m-%Y')}"+")" 
  end
  
  def hods        
    #works for both Diploma(eg. KP Radiografi) & Pos Basik/Pengkhususan/Dip Lanjutan(KP Pengkhususan) - note, creator among programmes lecturers only
    #unit_name=schedule_programme.name #not working for posbasiks
    approver=[]
    unless prepared_by.nil?
      unit_name=schedule_creator.positions.first.unit 
      kp_staffid = Position.unit_department_leader(unit_name).id
      approver << kp_staffid
    end
    sibkp_staffid=User.joins(:roles).where('roles.authname=?', "programme_manager").pluck(:userable_id).compact
    approver += sibkp_staffid #dup may exist
    approver.uniq
  end
  
  def self.location_list
    @ll=[] 
		@lecture_location = Location.where('code=?', 'C').first.descendants 
		@lecture_location.each do |kk| 
			if (kk.id == 89)||(kk.id == 90)||(kk.id == 906)||(kk.id == 907) ||(kk.id == 910)||(kk.id == 911)||(kk.id == 912)||(kk.id == 913) 
			   #do nothing
			else 
				@ll<< kk 
			end 
		end 
		return @ll
  end
  
  def approved_or_rejected
    #if is_submitted==true && submitted_on.blank? == false && hod_approved.blank? == false && hod_rejected.blank? == false
    #is_submitted is true and submitted_on is not null and hod_approved is null and hod_rejected is null
    if (is_submitted==true && submitted_on!=nil && hod_approved==nil && hod_rejected==nil && endorsed_by!=nil) || (hod_approved==true && hod_rejected==true)
      errors.add(:base, I18n.t('training.weeklytimetable.choose_approve_or_reject'))
    end
  end
  
  def self.empty_slot(timeslot,weeklytimetable,special)
    #1a-available time slots - Sun-Wed
    atsw = timeslot.pluck(:sequence)
    rev_all_timeslot_sun_wed = atsw+atsw.map{|x|x+=special}+atsw.map{|x|x+=(special*2)}+atsw.map{|x|x+=(special*3)}

    #0a-NEW weekdays (sun-wed)
    new_timeslot_sun_wed=[]
    new_day2_sun_wed=[]
    weeklytimetable.weeklytimetable_details.each do |xy|
      if xy.id.nil? || xy.id.blank?
        if xy.day2!=0 && (xy.day2!=5 || xy.day2!=6)
          new_timeslot_sun_wed<< xy.time_slot2
          new_day2_sun_wed<< xy.day2
        end
      end
    end
    
    #2a-START-existing time slot - Sun-Wed
    exist_timeslot_sun_wed = weeklytimetable.weeklytimetable_details.where('time_slot2 !=? and (day2!=? or day2!=?)',0,5,6).pluck(:time_slot2)
    exist_day2_sun_wed = weeklytimetable.weeklytimetable_details.where('day2 !=? and (day2!=? or day2!=?)',0,5,6).pluck(:day2)

    #rev_exist_slot = revised all existing slot, sample : weeklytimetable ID = 4
    #(eg. 4 days with 7 timeslot => [1, 3, 4, 6, 7, 8, 10, 11, 13, 14, 15, 17, 18, 20, 21, 22, 24, 25, 27, 28])
    rev_exist_slot=[]
    0.upto(exist_timeslot_sun_wed.count-1) do |ind_slot_day|
      if exist_day2_sun_wed[ind_slot_day] == 1
        rev_exist_slot<< exist_timeslot_sun_wed[ind_slot_day]
      else 
        rev_exist_slot<< exist_timeslot_sun_wed[ind_slot_day]+special*(exist_day2_sun_wed[ind_slot_day]-1)
      end
    end
    #new added to the same array-refer item (0a)	
    0.upto(new_timeslot_sun_wed.count-1) do |ind_slot_day|
      if new_day2_sun_wed[ind_slot_day] == 1
        rev_exist_slot<< new_timeslot_sun_wed[ind_slot_day]
      else
        rev_exist_slot<< new_timeslot_sun_wed[ind_slot_day]+special*(new_day2_sun_wed[ind_slot_day]-1)
      end
    end
    #2a-END-existing time slot - Sun-Wed

    #3a-empty time slots - Sun-Wed
    empty_slot= rev_all_timeslot_sun_wed - rev_exist_slot
  
  end
  
  def self.exist_timeslot_thurs(timeslot2,weeklytimetable,count1)
    #1b-available time slots - Thurs
    all_timeslot_thurs = timeslot2.pluck(:sequence)
    rev_all_timeslot_thurs = all_timeslot_thurs.map{|x|x+count1}

    #0b-NEW thursday
    new_timeslot_thurs=[]
    new_day2_thurs = 0  
    weeklytimetable.weeklytimetable_details.each do |xy|
      if xy.id.nil? || xy.id.blank?
        if xy.time_slot != 0
          new_timeslot_thurs<< xy.time_slot
        end
      end
    end
    
    #2b-existing time slots - Thurs
    exist_timeslot_thurs = weeklytimetable.weeklytimetable_details.where('time_slot !=?',0).pluck(:time_slot)
    #exist_day2_thurs = 0
    #new added to the same array-refer item (0c)
    if new_timeslot_thurs.count>0
      0.upto(new_timeslot_thurs.count-1) do |ind_slot_thurs|
        exist_timeslot_thurs<< new_timeslot_thurs[ind_slot_thurs]
      end
    end
    exist_timeslot_thurs
    
  end
  
  def self.empty_slot_weekend(timeslot,weeklytimetable,daycount_check)
    atsw = timeslot.pluck(:sequence)
    @special = weeklytimetable.timetable_monthurs.timetable_periods.count       #=@count1
    @count2 = weeklytimetable.timetable_friday.timetable_periods.count 
    #1c-available time slots - Weekends
    if daycount_check==1
      ##rev_all_timeslot_weekend = atsw.map{|x|x+=(@special*4)}
      #rev_all_timeslot_weekend = atsw.map{|x|x+=7*4+5)}
      rev_all_timeslot_weekend = atsw.map{|x|x+=(@special*4+@count2)}
    elsif daycount_check==2
      ## rev_all_timeslot_weekend = [34,36,37,39,40,41,43,44,46,47]
      #rev_all_timeslot_weekend = atsw.map{|x|x+=(7*4+5)}+atsw.map{|x|x+=(7*5+5)}
      rev_all_timeslot_weekend = atsw.map{|x|x+=(@special*4+@count2)}+atsw.map{|x|x+=(@special*5+@count2)}
      ##atsw.map{|x|x+=(@special*4)}+atsw.map{|x|x+=(@special*5)}
    end
    #0c-NEW weekends
    new_timeslot_1stday_weekend=[]
    new_timeslot_2ndday_weekend=[]
    new_day2_weekend=[] 
    weeklytimetable.weeklytimetable_details.each do |xy|
      if xy.id.nil? || xy.id.blank?
        if xy.day2==6 || xy.day2==7
          new_day2_weekend<< xy.day2
          if xy.day2==6
            new_timeslot_1stday_weekend<< xy.time_slot2
          elsif xy.day2==7
            new_timeslot_2ndday_weekend<< xy.time_slot2
          end
        end
      end
    end
    new_timeslot_weekend=new_timeslot_1stday_weekend+new_timeslot_2ndday_weekend.map{|y|y+=@special}

    #2c-START-existing time slot - Weekends
    exist_timeslot_1stday_weekend = weeklytimetable.weeklytimetable_details.where('day2=?',6).pluck(:time_slot2) 
    exist_timeslot_2ndday_weekend = weeklytimetable.weeklytimetable_details.where('day2=?',7).pluck(:time_slot2) 
    exist_timeslot_weekend = exist_timeslot_1stday_weekend+exist_timeslot_2ndday_weekend.map{|y|y+=@special}
    exist_day2_weekend = weeklytimetable.weeklytimetable_details.where('day2=? or day2=?',6,7).pluck(:day2)

    rev_exist_slot_weekend=[]
    if exist_timeslot_weekend.count>0
      0.upto(exist_timeslot_weekend.count-1) do |ind_slot_weekend|
        if exist_day2_weekend==[]
          nothing yet
        elsif exist_day2_weekend[ind_slot_weekend] == 1
          rev_exist_slot_weekend<< exist_timeslot_weekend[ind_slot_weekend] 
        else
          rev_exist_slot_weekend<< exist_timeslot_weekend[ind_slot_weekend]+(@special*4)+(@count2)
        end
      end
    end
    #new added to the same array-refer item (0c)
    if new_timeslot_weekend.count>0
      0.upto(new_timeslot_weekend.count-1) do |ind_slot_weekend|
        if new_day2_weekend==[]
          nothing yet
        elsif new_day2_weekend[ind_slot_weekend] == 1
          rev_exist_slot_weekend<< new_timeslot_weekend[ind_slot_weekend] 
        else
          rev_exist_slot_weekend<< new_timeslot_weekend[ind_slot_weekend]+(@special*4)+(@count2)
        end
      end
    end
    
    #3c-empty time slots - Weekends
    if daycount_check==1 || daycount_check==2
      #if exist_timeslot_weekend.count>0
      if rev_exist_slot_weekend.count>0
        empty_slot_weekend = rev_all_timeslot_weekend - rev_exist_slot_weekend
      else
        empty_slot_weekend = rev_all_timeslot_weekend
      end
    end
    empty_slot_weekend
  end
  
  def self.assign_error_items(weeklytimetable,item_type)
    weekdays_slots = weeklytimetable.timetable_monthurs.timetable_periods
    thursday_slots = weeklytimetable.timetable_friday.timetable_periods	

    a_eday2=[]
    a_etimeslot=[]
    a_etimeslot2=[]
    a_eis_friday=[]

    if (weeklytimetable.set_error_slot).is_a? Array
      weeklytimetable.set_error_slot.sort.each do |eslot|
        
        eyear=(eslot.split(" ")[0]).split("")[-4,4].join
        emonth=eslot.split("")[2,3].join
        eday=eslot.split("")[0,2].join
        edate = Date.new(eyear.to_i,Date::ABBR_MONTHNAMES.index(emonth),eday.to_i)
        estart_at = eslot.split(" ")[1].split("-")[0].to_time.strftime("%H:%M:%S")
        eend_at = eslot.split(" ")[1].split("-")[1].to_time.strftime("%H:%M:%S")
        dayyname=1 if edate.strftime("%A")!="Thursday"
        dayyname=2 if edate.strftime("%A")=="Thursday"
        
        if item_type==3 
          weekdays_slots.each do |slot|
            if slot.start_at.strftime("%H:%M:%S")==estart_at && slot.end_at.strftime("%H:%M:%S")==eend_at && slot.day_name==dayyname  #==1
              a_etimeslot2<< slot.sequence #slot.id
              a_etimeslot<< 0
            end
          end
        end
        if item_type==2 
          thursday_slots.each do |slot|
            if slot.start_at.strftime("%H:%M:%S")==estart_at && slot.end_at.strftime("%H:%M:%S")==eend_at && slot.day_name==dayyname #==2
              a_etimeslot<< slot.sequence #slot.id
              a_etimeslot2<< 0
            end
          end
        end
        
        if item_type==4 || item_type==1
          diff_day=(weeklytimetable.startdate-edate).to_i  #hari pertama
          eday2=1 if edate.strftime("%A")=="Sunday"# if diff_day==0
          eday2=2 if edate.strftime("%A")=="Monday"# if diff_day==1
          eday2=3 if edate.strftime("%A")=="Tuesday" # if diff_day==2
          eday2=4 if edate.strftime("%A")=="Wednesday"# if diff_day==3
          eday2=0 if edate.strftime("%A")=="Thursday" # if diff_day==-4 
          eday2=6 if edate.strftime("%A")=="Friday"# if diff_day==5
          eday2=7 if edate.strftime("%A")=="Saturday"# if diff_day==6
          if item_type==1
            a_eday2<< eday2 if eday2!=0
          end
          @eday2=0 if eday2==0
          @eis_friday=true if eday2==0 #diff_day==-4
          eis_friday=false if (eday2==1 || eday2==2 ||eday2==3 || eday2==4 || eday2==6 || eday2==7)
          a_eis_friday<< eis_friday
        end
      end
    end
    return a_eday2 << @eday2 if item_type==1
    return a_etimeslot if item_type==2
    return a_etimeslot2 if item_type==3
    return a_eis_friday.compact << @eis_friday if item_type==4
  end
  
  private
    def intake_must_match_with_programme
      valid_intakes = Intake.where(programme_id: programme_id).pluck(:id)
      if valid_intakes.include?(intake_id)
        return true
      else
        errors.add(:base, I18n.t('training.weeklytimetable.intake_programme_must_match'))
        return false
      end
    end
  
end

# == Schema Information
#
# Table name: weeklytimetables
#
#  created_at      :datetime
#  enddate         :date
#  endorsed_by     :integer
#  format1         :integer
#  format2         :integer
#  group_id        :integer
#  hod_approved    :boolean
#  hod_approved_on :date
#  hod_rejected    :boolean
#  hod_rejected_on :date
#  id              :integer          not null, primary key
#  intake_id       :integer
#  is_submitted    :boolean
#  prepared_by     :integer
#  programme_id    :integer
#  reason          :string(255)
#  semester        :integer
#  startdate       :date
#  submitted_on    :date
#  updated_at      :datetime
#  week            :integer
#
