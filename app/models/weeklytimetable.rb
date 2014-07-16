class Weeklytimetable < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  
  #before_save :set_semester
  before_save :set_to_nil_where_false
  before_save :manual_remove_details_if_marked, prepend: true
  
  belongs_to :schedule_programme, :class_name => 'Programme',       :foreign_key => 'programme_id'
  belongs_to :schedule_semester,  :class_name => 'Programme',       :foreign_key => 'semester'
  belongs_to :schedule_intake,    :class_name => 'Intake',          :foreign_key => 'intake_id' 
  belongs_to :schedule_creator,   :class_name => 'Staff',           :foreign_key => 'prepared_by'
  belongs_to :schedule_approver,  :class_name => 'Staff',           :foreign_key => 'endorsed_by'
  belongs_to :timetable_monthurs, :class_name => 'Timetable',       :foreign_key => 'format1'
  belongs_to :timetable_friday,   :class_name => 'Timetable',       :foreign_key => 'format2'
  belongs_to :academic_semester,  :class_name => 'AcademicSession', :foreign_key => 'semester'
  
  has_many :weeklytimetable_details, :dependent => :destroy
  accepts_nested_attributes_for :weeklytimetable_details, :reject_if => proc {|a|a['topic'].blank? || a['lecturer_id'].blank? || a['lecture_method'].blank?} 

  validates_presence_of :programme_id, :semester, :intake_id, :format1, :format2
  validate :approved_or_rejected, :restrict_lecturer_per_class_duration
  
  attr_accessor :set_error_slot
  
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

  def restrict_lecturer_per_class_duration #------
    count_errors=0
    count_marked2=0
    current_date_period=[]
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
        new_lecturer<<wd.lecturer_id
      else
        new_lecturer<<wd.lecturer_id
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
        sdate=x.weeklytimetable.startdate
        if x.is_friday == true
          current_date = (sdate+4).try(:strftime, "%d%b%Y")
          period_start = TimetablePeriod.where(id:x.time_slot)[0].start_at
          period_end = TimetablePeriod.where(id:x.time_slot)[0].end_at
          period = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          unless x.subject.nil? || x.subject.blank?
            current_date_period << current_date +" "+ period+" "+x.subject.to_s+" "+lecturer.to_s#+" "+x.id.to_s
          else
            current_date_period << current_date +" "+ period+" "+"0"+" "+lecturer.to_s#+" "+x.id.to_s
          end
        else
          current_date2 = sdate.try(:strftime, "%d%b%Y") if x.day2==1        #weekdays
          current_date2 = (sdate+1).try(:strftime, "%d%b%Y") if x.day2==2    
          current_date2 = (sdate+2).try(:strftime, "%d%b%Y") if x.day2==3
          current_date2 = (sdate+3).try(:strftime, "%d%b%Y") if x.day2==4
          current_date2 = (sdate+5).try(:strftime, "%d%b%Y") if x.day2==6    #weekends
          current_date2 = (sdate+6).try(:strftime, "%d%b%Y") if x.day2==7  
          period_start = TimetablePeriod.where(id:x.time_slot2)[0].start_at
          period_end = TimetablePeriod.where(id:x.time_slot2)[0].end_at
          period2 = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          unless x.subject.nil? || x.subject.blank?
            current_date_period << current_date2 +" "+ period2+" "+x.subject.to_s+" "+lecturer.to_s#+" "+x.id.to_s
          else
            current_date_period << current_date2 +" "+ period2+" "+"0"+" "+lecturer.to_s#+" "+x.id.to_s
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
        if y.is_friday == true
          current_date = (startdate+4).try(:strftime,"%d%b%Y")
          period_start = TimetablePeriod.where(id:y.time_slot)[0].start_at
          period_end = TimetablePeriod.where(id:y.time_slot)[0].end_at
          period = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          current_date_period << current_date +" "+ period+" "+y.subject.to_s+" "+l.to_s#+" "+y.id.to_s
        else
          current_date2 = startdate.try(:strftime, "%d%b%Y") if y.day2==1    #weekdays
          current_date2 = (startdate+1).try(:strftime, "%d%b%Y") if y.day2==2    
          current_date2 = (startdate+2).try(:strftime, "%d%b%Y") if y.day2==3
          current_date2 = (startdate+3).try(:strftime, "%d%b%Y") if y.day2==4
          current_date2 = (startdate+5).try(:strftime, "%d%b%Y") if y.day2==6    #weekends
          current_date2 = (startdate+6).try(:strftime, "%d%b%Y") if y.day2==7 
          period_start = TimetablePeriod.where(id:y.time_slot2)[0].start_at
          period_end = TimetablePeriod.where(id:y.time_slot2)[0].end_at
          period2 = period_start.try(:strftime, "%H:%M%P")+"-"+period_end.try(:strftime, "%H:%M%P")
          current_date_period << current_date2 +" "+ period2+" "+y.subject.to_s+" "+l.to_s#+" "+y.id.to_s    
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
        cdp<<([splitter3[0]]+[splitter3[1]]+["0"]+[splitter3[2]]).join(" ")
      else
        cdp<<j
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
                error_slots<<splitter2[0]+" "+splitter2[1]#+item_count.to_s+count_e.to_s+"yoyo"
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
                error_slots<<splitter2[0]+" "+splitter2[1]#+item_count.to_s+count_e.to_s+"yaya"
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
      @all_error_slots<<es#+"yiyi"
    end
    error_lines=""
    @all_error_slots.each_with_index do |error_line,ind|
      el = error_line.split(" ")
      error_lines+= "("+(ind+1).to_s+") "+I18n.t('training.weeklytimetable.date_time')+el[0]+" "+el[1]+" "
    end
    #END - Currently EDIT
    
    if count_errors>0       
      errors.add(:base, I18n.t('training.weeklytimetable.duplicate_lecturer')+" #{error_lines}")
      #errors.add(:base, "#{count_marked2} #{count_errors} #{details2.count} #{details_g_lecturer.count}-#{current_date_period}+#{current_date_period.uniq} * #{current_lecturer} ==#{new_lecturer} ~~#{current_wd} ` #{current_date_period.count}==`#{current_date_period.uniq.count}--->#{@all_error_slots}")
      self.set_error_slot = @all_error_slots.uniq
    end
  end#------
 
  #attr_accessor :subject_id  #for testing grouped programme (subject)
  #before logic
  def set_to_nil_where_false
    if is_submitted == true
      self.submitted_on	= Date.today
    end
    
    if hod_approved == false
      self.hod_approved_on	= nil
    end
    
    if hod_rejected == true && endorsed_by == User.current_user.staff_id
      self.is_submitted = nil
   end
    
  end

  #def self.search(search)
    #if search         
      #@weeklytimetables = Weeklytimetable.find(:all,:conditions => ['programme_id=?', search])
      #else
      #@weeklytimetables = Weeklytimetable.find(:all)
      #end
  #end

  def main_details_for_weekly_timetable
    "#{schedule_programme.programme_list}"+" Intake : "+"#{schedule_intake.name}" +" - (Week : "+"#{startdate.strftime('%d-%m-%Y')}"+" - "+"#{enddate.strftime('%d-%m-%Y')}"+")" 
  end
  
  def hods  
      #hod = User.current_user.staff.position.parent
      current_user = User.find(11)    #maslinda 
      #current_user = User.find(72)    #izmohdzaki      
      approver = Position.where('tasks_main like? or (tasks_other like? and is_acting=?) or unit=?', "%Ketua Program%", "%Ketua Program%",true, Programme.find(programme_id).name).pluck(:staff_id).compact
    
      #Ketua Program - ancestry_depth.2
      #hod = Position.find(:all, :conditions => ["ancestry=?","1/2"])
      
      #if User.current_user.staff.position.root_id == User.current_user.staff.position.parent_id
        #hod = User.current_user.staff.position.root_id
        #approver = Position.find(:all, :select => "staff_id", :conditions => ["id IN (?)", hod]).map(&:staff_id)
      #else
        #hod = User.current_user.staff.position.root.child_ids
        #approver = Position.find(:all, :select => "staff_id", :conditions => ["id IN (?)", hod]).map(&:staff_id)
      #end
      #approver
  end
  
  def self.location_list
    @ll=[] 
		@lecture_location = Location.find(:first, :conditions=>['code=?', 'C']).descendants 
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
    if hod_approved.blank? == false && hod_rejected.blank? == false
        errors.add_to_base("Please choose either to approve or reject this weekly timetable")
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
