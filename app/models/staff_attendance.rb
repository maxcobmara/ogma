class StaffAttendance < ActiveRecord::Base
  include Spreadsheet2
  
  # befores, relationships, validations, before logic, validation logic, 
  # controller searches, variables, lists, relationship checking
  
  before_save :update_trigger_isapproved
  
  belongs_to :college
  belongs_to :attended, :class_name => 'Staff', :foreign_key => 'thumb_id', :primary_key => 'thumb_id'
  belongs_to :approver, :class_name => 'Staff', :foreign_key => 'approved_by'
  
  attr_accessor :userid, :checktime, :checktype, :name, :birthday, :defaultdeptid, :deptid, :deptname, :thumbid, :icno, :hname, :hdate	#from excel
  
  validates_presence_of :reason, :if => :fingerprint_issued?        
  
  def fingerprint_issued?
    if trigger && trigger==true  && status != nil
      return true
    else
      return false
    end
  end
      
  def update_trigger_isapproved
    if id.nil?|| id.blank? 
      if trigger=="0" || trigger==false
	self.trigger=nil
      end 
      if (is_approved=="0" || is_approved==false)
	self.is_approved=nil
      end
    end
  end  
  
  def self.import(file) 
    spreadsheet = Spreadsheet2.open_spreadsheet(file)  				#open/read excel file
    StaffAttendanceHelper.update_holidays(spreadsheet)
    staff_dept = StaffAttendanceHelper.update_thumb_id(spreadsheet)			#update thumb_id - table : staffs & return staff_id & deptid
    userid_thumbid = StaffAttendanceHelper.userid_thumbid(spreadsheet)			#just retrieve match of userid & thumbid
    result = StaffAttendanceHelper.update_attendance(spreadsheet,userid_thumbid)				#update attendance record - table : staff_attendances    
    dept_list = StaffAttendanceHelper.load_dept(spreadsheet)					#load department id & names fr excel {1: "KSKB",2: "Pengurusan Pentadbiran"}
    StaffAttendanceHelper.match_dept_unit(staff_dept,dept_list)
    return result
  end
  
  def self.messages(import_result) 
    StaffAttendanceHelper.msg_import(import_result)
  end
   
  # define scope
  def self.keyword_search(query) 
    thumb_ids=StaffAttendance.get_thumb_ids_unit_names(1)
    #where('thumb_id IN(?) and logged_at >? and logged_at<?',  thumb_ids[query.to_i],'2012-09-30','2012-11-01') 
    where('thumb_id IN(?)',  thumb_ids[query.to_i])
    
    #where('thumb_id IN(?) and logged_at >? and logged_at<?', all_thumb_ids, '2012-09-30','2012-11-01')  		#not working
    #where('thumb_id IN(?)',  thumb_ids[query.to_i])													#best working one
    #where(thumb_id: query)																	#working one
    #where('thumb_id IN(?)', [756,757]) if query=='1'												#also works nicely
  end
  
  def self.attended_search(query)
    thumb_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:thumb_id)
    where('thumb_id IN(?)', thumb_ids)
  end
  
  def self.approver_search(query)
    staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    where('approved_by IN(?)', staff_ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search, :attended_search, :approver_search]
  end

  def self.staff_with_unit_groupbyunit
    Staff.joins(:positions).where('unit is not null and unit!=?',"").group_by{|x|x.positions.first.unit}
   
    # START--solution for - NoMethodError in Staff::StaffAttendances#index, Showing /home/shimah/rails/ogma/app/views/staff/staff_attendances/index.html.haml where line #80 raised:undefined method `start_at' for nil:NilClass
    #Staff.joins(:positions).where('positions.staff_id is not null and staff_shift_id is not null and staffs.thumb_id is not null and unit is not null and unit!=?  and positions.name!=?', '', "ICMS Vendor Admin").group_by{|x|x.positions.first.unit}
    # END--solution - but this will restrict to limited department / units only -- unit w/o complete staff_id, staff_shift_id & thumb_id wont be displayed in INDEX
    #refer method .get_thumb_ids_unit_names() below.
    
    #Staff.joins(:positions).where('unit is not null and unit!=?',"").order('positions.combo_code ASC').group_by{|x|x.positions.first.unit}
    #Staff.joins(:positions,:staffgrade).where('unit is not null and unit!=?',"").order('group_id, positions.combo_code ASC').group_by{|x|x.positions.first.unit}	#best ever
    #Staff.joins(:positions,:staffgrade).where('unit is not null and unit!=?',"").sort_by{|u|u.staffgrade.gred_no}.reverse!.group_by{|x|x.positions.first.unit} #better
  end
  
  def self.get_thumb_ids_unit_names_amsas
    unit_staffdetails=[]
    StaffAttendance.staff_with_unit_groupbyunit.each{|u_name,staffs| unit_staffdetails << [u_name, staffs.map(&:name_id) ]}
    unit_staffdetails
    
#     @unit_staffs2=[]
#     a=StaffAttendance.staff_with_unit_groupbyunit
#     a.each do |u_name,staffs|
#       staffs.each do |astaff|
#         @unit_staffs2 << [astaff.name, astaff.id] if astaff.positions.first.name != "ICMS Vendor Admin" || astaff.icno!="123456789012"
#       end
#       @name_id22 = [@p_name2, @unit_staffs2]
#       end
#       @name_id << @name_id22
#     end
#     @name_id
  end
  
  def self.get_thumb_ids_unit_names(val)
    
    a=StaffAttendance.staff_with_unit_groupbyunit
    comb_pengkhususan=["Pengkhususan", "Pos Basik", "Diploma Lanjutan"]
    
    #refer above--this will display all department / unit in INDEX & SEARCH select field - although w/out complete staff_shiftid & thumb_id(staffs)& staff_id(positions)
    valid_staff=Staff.joins(:positions).where('positions.staff_id is not null and staff_shift_id is not null and thumb_id is not null and positions.unit is not null and positions.unit!=? and positions.name!=?', '', "ICMS Vendor Admin").pluck(:id)
    invalid_staff=Staff.joins(:positions).where('positions.staff_id is not null and (staff_shift_id is null or thumb_id is null) and positions.unit is not null and positions.unit!=?and positions.name!=?', '', "ICMS Vendor Admin").pluck(:id)
    valid_unit=Position.where(staff_id: valid_staff).pluck(:unit).uniq.compact-[""]
    invalid_unit=Position.where(staff_id: invalid_staff).pluck(:unit).uniq.compact-[""]
    valid_dept=valid_unit-invalid_unit
    #---

    thmb=[] if val==1
    uname=[] if val==2
    uname4=[] if val==4
    uname_thmb=[] if val==3
    @name_id=[]
    @count=0
    @count2=0
    @count3=0
    @p_name = "Pengkhususan"
    @p_name2= "Pentadbiran Am"
    @p_staffs=[]
    @p_staffs2=[]
    @unit_staffs=[]
    @unit_staffs2=[]
    
    a.each do |u_name,staffs|
      if comb_pengkhususan.include?(u_name)
        #combine advance programme - START
        if valid_dept.include?(u_name)==false && @count==0
          @p_name="-- Pengkhususan"
          @count+=1
        end
        @p_staffs += staffs.map(&:thumb_id).compact
        #@unit_staffs=[]
        staffs.each do |astaff|
          @unit_staffs << [astaff.name, astaff.id] if astaff.positions.first.name != "ICMS Vendor Admin" || astaff.icno!="123456789012"
        end
        @name_id2 = [@p_name, @unit_staffs]
        #combine advance programme - END
      elsif u_name=="Pentadbiran" || u_name=="Pentadbiran Am"
        if valid_dept.include?(u_name)==false && @count3==0
          @p_name2="-- Pentadbiran Am"
          @count3+=1
        end
	@p_staffs2 += staffs.map(&:thumb_id).compact
        #@unit_staffs2=[]
        staffs.each do |astaff|
          @unit_staffs2 << [astaff.name, astaff.id] if astaff.positions.first.name != "ICMS Vendor Admin" || astaff.icno!="123456789012"
        end
	@name_id22 = [@p_name2, @unit_staffs2]
      else 
        ###diploma - START
        thmb<< staffs.map(&:thumb_id).compact if val==1
        uname<< u_name if val==2
        u_name2=u_name
        u_name2="-- "+u_name if valid_dept.include?(u_name)==false #add remark "-- " before unit name, search for these units/departments error shall arise
      
        if val==3
          u_t=[]
          u_t<< u_name2<< @count2
          uname_thmb << u_t 
          @count2+=1
        end
      
        #additional for use in Attendance Report (select field) - START
        uname4<< u_name2 if val==4 
        if val==5
          unit_staffs=[]
          staffs.each do |astaff|
            unit_staffs << [astaff.name, astaff.id] if astaff.positions.first.name != "ICMS Vendor Admin" || astaff.icno!="123456789012"
          end
          @name_id << [u_name2, unit_staffs]
        end
        #additional for use in Attendance Report (select field) - END
        ###diploma - END
      end
    end
     thmb << @p_staffs if val==1
     thmb << @p_staffs2 if val==1
     uname << @p_name if val==2 
     uname << @p_name2 if val==2 
     if val==3
       u_t=[]
       u_t<< @p_name << @count2 
       uname_thmb << u_t
       u_t2=[]
       u_t2<< @p_name2 << @count2+1
       uname_thmb << u_t2
     end
     uname4 << @p_name if val==4
     uname4 << @p_name2 if val==4
     @name_id << @name_id2 if val==5
     @name_id << @name_id22 if val==5
    
    return thmb if val==1
    return uname if val==2
    return uname_thmb if val==3
    return uname4 if val==4
    return @name_id if val==5
  end
  
  def self.thumb_ids_all
    thumb_ids =  StaffAttendance.get_thumb_ids_unit_names(1)
    all_thumb_ids = []
    thumb_ids.each do |thumb_ids|
      all_thumb_ids+= thumb_ids
    end
    all_thumb_ids
  end
  
  def self.unit_for_thumb(attendance_thumb_id)
    thumb_by_dept=StaffAttendance.get_thumb_ids_unit_names(1)
    dept_names=StaffAttendance.get_thumb_ids_unit_names(2)
    thumb_by_dept.each_with_index do |thumbs, ind|
      @dept_name=dept_names[ind] if thumbs.include?(attendance_thumb_id)
    end 
    @dept_name
  end

  def self.is_controlled
    #find(:all, :order => 'logged_at DESC', :limit => 10000)
    #joins(:attended).where('staffs.staff_shift_id is not null').limit(10000).order(logged_at: :desc)
    tday=Time.now.beginning_of_day
    #joins(:attended).where('staffs.staff_shift_id is not null').where('logged_at <=?', tday+2.years).order(logged_at: :desc)
  end
  
  def self.triggered
    tday=Time.now.beginning_of_day
    joins(:attended).where('staffs.staff_shift_id is not null').where('logged_at <=?', tday+2.years).where(trigger: true).order(logged_at: :desc)
  end

  def self.find_mylate(curr_user)
     staffshift_id = curr_user.userable.staff_shift_id
     curr_thumb_id = curr_user.userable.thumb_id   
#      if staffshift_id != nil 
#        if curr_user.userable.shift_histories.count==0
#           start_time = StaffShift.find(staffshift_id).start_at.strftime("%H:%M") 
#        else
#          sas=StaffAttendance.where(thumb_id: curr_thumb_id)#, trigger: true)
#          @sa_lateness=[]
#          sas.each do |sa|
#            curr_date=sa.logged_at.to_date #strftime('%Y-%m-%d')
#            shiftid = StaffShift.shift_id_in_use(curr_date, curr_thumb_id)
#            @sa_lateness << sa.id if sa.r_u_late(shiftid)=="flag"
#          end
#        end
#      else
#        start_time = "08:00"
#      end
#      unless @sa_lateness.nil?
#        a=StaffAttendance.where(id: @sa_lateness, thumb_id: curr_thumb_id, trigger: true).order(logged_at: :desc) 
#      else
#       a=StaffAttendance.where("trigger=? AND log_type =? AND thumb_id=? AND logged_at::time > ?", true, "I",curr_thumb_id, start_time).order('logged_at') 
#      end
#      a
     StaffAttendance.where(thumb_id: curr_thumb_id, trigger: true).where('log_type=? or log_type=?', 'I', 'i')
  end
  
  def self.find_myearly(curr_user)
     staffshift_id = curr_user.userable.staff_shift_id
     curr_thumb_id= curr_user.userable.thumb_id

# prob : thumb id null    
#temporary HIDE - Index (trigger / ignore / flag - shift histories already applied - history shift, note : use r_u_late(shift_id) & r_u_early(shift_id) on all SA record, so trigger == true will only happen when sa (r_u_late(shift_id)=="flag" or r_u_early(shift_id)=="flag")
#      if staffshift_id != nil
#        if curr_user.userable.shift_histories.count==0
#          end_time = StaffShift.find(staffshift_id).end_at.strftime("%H:%M") 
#        else
#          sas=StaffAttendance.where(thumb_id: curr_thumb_id)#, trigger: true)
#          @sa_early=[]
#          sas.each do |sa|
#            curr_date=sa.logged_at.to_date  #strftime('%Y-%m-%d')
#            shiftid = StaffShift.shift_id_in_use(curr_date, curr_thumb_id)
#            @sa_early << sa.id if sa.r_u_early(shiftid)=="flag"
#          end
#        end
#      else
#        end_time = "17:00"
#      end
#       unless @sa_early.nil?
#         b=StaffAttendance.where(id: @sa_early, thumb_id: curr_thumb_id, trigger: true).order(logged_at: :desc) 
#       else
#        b=StaffAttendance.where("trigger=? AND log_type =? AND thumb_id=? AND logged_at::time < ?", true, "O", curr_thumb_id, end_time).order(:logged_at)
#      end
#      b

     StaffAttendance.where(thumb_id: curr_thumb_id, trigger: true).where('log_type=? or log_type=?', 'O', 'o')
  end
  
  def i_have_a_thumb
    if User.current_user.staff.thumb_id == nil
      5658
    else
      User.current_user.staff.thumb_id
    end
  end 
  
  def self.find_approvelate(current_user)
    all.where("trigger=? AND log_type =? AND thumb_id IN (?)", true, "I", peeps(current_user)).order('logged_at DESC')
  end
  
  def self.find_approveearly(current_user)
    all.where("trigger=? AND log_type =? AND thumb_id IN (?)",true ,"O", peeps(current_user)).order('logged_at DESC')
  end
  
  def self.this_month_red
    red_peeps_this_month = StaffAttendance.count(:all, :group => :thumb_id, :conditions => ["trigger = ? AND logged_at BETWEEN ? AND ?", true, Date.today.beginning_of_month, Date.today])
    arr = Array(red_peeps_this_month)
    arr = arr.reject { |a, b| b < 5 }
    arr = arr.sort! { |a, b| b.second <=> a.second }
    arr
  end
  
  def self.last_month_red
    red_peeps_this_month = StaffAttendance.count(:all, :group => :thumb_id, :conditions => ["trigger = ? AND logged_at BETWEEN ? AND ?", true, Date.today.prev_month.beginning_of_month, Date.today.prev_month.end_of_month])
    arr = Array(red_peeps_this_month)
    arr = arr.reject { |a, b| b < 5 }
    arr = arr.sort! { |a, b| b.second <=> a.second }
    arr
  end
  
  def self.previous_month_red
    red_peeps_this_month = StaffAttendance.count(:all, :group => :thumb_id, :conditions => ["trigger = ? AND logged_at BETWEEN ? AND ?", true, Date.today.months_ago(2).beginning_of_month, Date.today.months_ago(2).end_of_month])
    arr = Array(red_peeps_this_month)
    arr = arr.reject { |a, b| b < 5 }
    arr = arr.sort! { |a, b| b.second <=> a.second }
    arr
  end
  
  def self.this_month_green
    red_peeps_this_month = StaffAttendance.count(:all, :group => :thumb_id, :conditions => ["trigger = ? AND logged_at BETWEEN ? AND ?", true, Date.today.beginning_of_month, Date.today])
    arr = Array(red_peeps_this_month)
    arr = arr.reject { |a, b| b < 3 || b > 4 }
    arr = arr.sort! { |a, b| b.second <=> a.second }
    arr
  end
  
  def self.last_month_green
    red_peeps_this_month = StaffAttendance.count(:all, :group => :thumb_id, :conditions => ["trigger = ? AND logged_at BETWEEN ? AND ?", true, Date.today.prev_month.beginning_of_month, Date.today.prev_month.end_of_month])
    arr = Array(red_peeps_this_month)
    arr = arr.reject { |a, b| b < 3 || b > 4 }
    arr = arr.sort! { |a, b| b.second <=> a.second }
    arr
  end
  
  def self.previous_month_green
    red_peeps_this_month = StaffAttendance.count(:all, :group => :thumb_id, :conditions => ["trigger = ? AND logged_at BETWEEN ? AND ?", true, Date.today.months_ago(2).beginning_of_month, Date.today.months_ago(2).end_of_month])
    arr = Array(red_peeps_this_month)
    arr = arr.reject { |a, b| b < 3 || b > 4 }
    arr = arr.sort! { |a, b| b.second <=> a.second }
    arr
  end
  
  def self.peeps(current_user)
    mypost = Position.where(staff_id: current_user.userable_id).first
    myunit = mypost.unit
    mythumbid = current_user.userable.thumb_id
    iamleader=Position.am_i_leader(current_user.userable_id)
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
      
      if leader_staffid==current_user.userable_id #when current user is unit/department leader
        thumbs=Staff.joins(:positions).where('staffs.thumb_id!=? and unit=?', mythumbid, myunit).pluck(:thumb_id)
        #when current user is Pengarah, above shall collect all timbalans thumb id plus academicians leader (Ketua Program)
        if current_user.userable_id==Position.roots.first.staff_id
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
  end
  
  

#   def self.peeps2(current_user)
#     myunit = Position.where(staff_id: current_user.userable_id).first.unit
#     mythumbid = current_user.userable.thumb_id
#     iamleader=Position.am_i_leader(current_user)
#     if iamleader== true   #check by roles
#       thumbs=Staff.joins(:positions).where('staffs.thumb_id!=? and unit=?', mythumbid, myunit).pluck(:thumb_id)
#     else #check by rank / grade
#       leader_staffid=Position.unit_department_leader(myunit).id   #return Staff(id) record ofunit/dept leader
#       if leader_staffid==current_user.userable_id
#         thumbs=Staff.joins(:positions).where('staffs.thumb_id!=? and unit=?', mythumbid, myunit).pluck(:thumb_id)
#       else
#         thumbs=[]
#       end
#     end
#     thumbs
#   end
    
  def attendee_details 
      if attended.blank?
        thumb_id.to_s + " - " +"Thumb ID not reged"
      elsif thumb_id?
        attended.name
      else 
      end
  end
  
  def group_by_thingy
    logged_at.to_date.to_s                       #hide on 21June2013
    #logged_at.in_time_zone('UTC').to_date.to_s    #- AMENDED 21JUNE2013
  end
  
  def r_u_late(shiftid)
    if log_type=="I"
	mins = logged_at.min.to_s
		    #---
		    #shift = Staff.find(:first, :conditions => ['thumb_id=?',thumb_id]).staff_shift_id 
		    #if shift != nil
			#shift_start = StaffShift.find(shift).start_at
			#starting_time = (shift_start.strftime('%H').to_i * 100) + shift_start.strftime('%M').to_i
		    #else
			#starting_time = 830
		    #end
		    #---
	if mins.size == 1
	  mins = "0" + mins
	end
	timmy = ((logged_at.hour - 0).to_s + mins).to_i			#timmy = ((logged_at.hour - 8).to_s + mins).to_i
	if timmy > starting_shift(shiftid.to_i) && self.trigger != false    #if timmy > starting_time && self.trigger != false  #if timmy > 830 && self.trigger != false
	  "flag"
	else #***
	end
    end	#end for log_type=="I"
  end
  
  def r_u_early(shiftid)
      mins = logged_at.min.to_s
      if mins.size == 1
         mins = "0" + mins
      end
      if log_type == 'O' || log_type == 'o'
	  timmy = (logged_at.strftime('%H%M')).to_i 
          #timmy = (logged_at.in_time_zone('UTC').strftime('%H%M')).to_i   #giving this format 1800 @ #0840 -> 840 --> if 00:02 will become 2
          if timmy < ending_shift(shiftid) && self.trigger != false 
              "flag"
	      #if  timmy2 < 0  #(&& timmy2 < 0)to work with logout at time after 12:00 midnight --> 00:00hrs
		#"flag"
          else 
              if ending_shift(shiftid) == 700 #yg tak de shift
                  if timmy < 1700
                      "flag"
                  end
              end
          end
      end   #end for if log_type == 'O'
  end

  
  def timmy2
    mins = logged_at.min.to_s
    if mins.size == 1
      mins = "0" + mins
    end
    #timmy = ((logged_at.hour - 8).to_s + mins).to_i			#previously 8 hours difference?
    timmy = ((logged_at.hour - 0).to_s + mins).to_i
  end
  
  #--added use for r_u_late & late_early
  def starting_shift(shiftid)
    shift = shiftid.to_i #Staff.where(thumb_id: thumb_id).first.staff_shift_id 
    if shift==nil
      #shift= Staff.where(thumb_id: 5658).first.staff_shift_id
      shift = Login.first.staff.staff_shift_id
    end
    
		if shift != nil
		  #shift_start = StaffShift.find(shift).start_at
		  shift_start = StaffShift.where(id: shift).first.start_at
		  (shift_start.strftime('%H').to_i * 100) + shift_start.strftime('%M').to_i
		else
		  800 #830 -> (800 -- 8.00 am) 
		end
  end
  
  def ending_shift(shift_id_use)        #return this format -> 1800
    shift = shift_id_use#Staff.where(thumb_id: thumb_id).first.staff_shift_id 
    if shift == nil
      #shift = Staff.where(thumb_id: 5658).first.staff_shift_id    
      shift = Login.first.staff.staff_shift_id
    end
		if shift != nil
		  #shift_end = StaffShift.find(shift).end_at
		  shift_end = StaffShift.where(id: shift).first.end_at
		  #(shift_end.strftime('%H').to_i * 100) + shift_end.strftime('%M').to_i  #(shift_end.strftime('%H').to_i)* 100 + shift_end.strftime('%M').to_i
		  (shift_end.strftime('%H%M').to_i)
		else
		  1700#700 #730 -> (700 -- 5.00 pm)  ##TEMPORARY SOLUTION - FAILED TO SEND VALUE as 1700 -> refer line 214-221
		end
  end
  #--added use for r_u_late & late_early
  
  def late_early(shift_id_use)
    mins = logged_at.min.to_s
    #----------------------start---------for logged-in
    if log_type=='I'  
        #----  #replace (timmy = timmy2 ) 161-166 
        #if mins.size == 1
            #mins = "0" + mins
        #end
        #timmy = ((logged_at.hour - 8).to_s + mins).to_i 
        #----
        shift = shift_id_use.to_i #Staff.where(thumb_id: thumb_id).first.staff_shift_id 
	if shift== nil
	    #shift = Staff.where(thumb_id: 5658).first.staff_shift_id
	  shift = Login.first.staff.staff_shift_id
	end
    	#minit_shift = (StaffShift.find(shift).start_at.min) if shift != nil
    	minit_shift = (StaffShift.where(id: shift).first.start_at.min) if shift != nil
        
        
        if timmy2 > starting_shift(shift_id_use.to_i) && self.trigger != false           #if 822 > 730 && self.trigger != false
            diff = timmy2-starting_shift(shift_id_use.to_i) #(822-730)            
            if minit_shift!=nil && mins.to_i < minit_shift                          #if 22 < 30
                minit_diff = ((mins.to_i+60)-minit_shift)
                #late = ((diff/100)-1).to_s+" hours " 
                #$$$$$$-----------------------------
                if diff > 99 && minit_diff <= 0 
                    late = (diff/100).to_s+" hours "
                elsif diff > 99 && minit_diff > 0 
                    late = (diff/100).to_s+" hours "+"#{minit_diff} minutes"
                elsif minit_diff > 0 && diff < 100
                    late ="#{minit_diff} minutes"
                end
                
                #$$$$$$-----------------------------
            else
                if diff > 99 
                    late = (diff/100).to_i.to_s+" hours " + (diff % 100).to_s+" minutes "       #in hours & minutes
                    #late = (((diff/100)* 60) + (diff % 100)).to_s + " minutes"           #in minutes only       
                else
                    late = "#{diff} minutes"
                end
            end
            #######
            late
            ######
        else
            "-"#"punctual #{timmy2} ~ #{starting_shift}"#  "punctual-masuk" 
        end
    #----------------------end---------for logged-in
    elsif log_type == 'O' 
    #----------------------start------for logged-out
      #shift = Staff.find(:first, :conditions => ['thumb_id=?',thumb_id]).first.staff_shift_id 
      shift = shift_id_use.to_i #Staff.where(thumb_id: thumb_id).first.staff_shift_id
      if shift==nil
	  #shift = Staff.where(thumb_id: 5658).first.staff_shift_id
	   shift= Login.first.staff.staff_shift_id
      end
  		if shift != nil
  		    #shift_end = StaffShift.find(shift).end_at
  		    shift_end = StaffShift.where(id: shift).first.end_at
  		    #==================
  		    #minit_shift = (StaffShift.find(shift).end_at.min)
  		    minit_shift = (StaffShift.where(id: shift).first.end_at.min)
    		  if minit_shift == 0  
    			    #jam = ( (StaffShift.find(shift).end_at.strftime('%H').to_i) - 8)-1
    			    jam = ( (StaffShift.where(id: shift).first.end_at.strftime('%H').to_i) - 8)-1
    			    minit = 60
    		  else
    		      #jam = (StaffShift.find(shift).end_at.strftime('%H').to_i) - 8
    		      jam = (StaffShift.where(id: shift).first.end_at.strftime('%H').to_i) - 8
    		      minit = minit_shift
    		  end
		  ######
		  minit=minit_shift
		  jam=(StaffShift.where(id: shift).first.end_at.strftime('%H').to_i) - 8
		  ######
  		    #==================
  		else
  		    #1700 --> 8j60m (if shift end at 5pm)
  		    #1800 --> 9j60m (if shift end at 6pm)
  		    jam = 8 #9
  		    minit = 60 
  		end
      #--------
      if mins.size == 1
        mins = "0" + mins
      end
      ##*****
      meridian = (logged_at.strftime('%P'))	#am or pm
      #meridian = (logged_at.in_time_zone('UTC').strftime('%P'))	#am or pm
      timmy_jam = ((logged_at.strftime('%l')).to_i)-8 
      #timmy_jam = ((logged_at.in_time_zone('UTC').strftime('%l')).to_i)-8 #logged_at.hour.to_s		#previously 8 hours difference?
      #timmy_jam = ((logged_at.in_time_zone('UTC').strftime('%H')).to_i)-0 #logged_at.hour.to_s
      timmy_jam = 1200+timmy_jam  if meridian=="pm"
      timmy_minutes = mins.to_i
      ##*****
                #=h sa.logged_at.in_time_zone('UTC').strftime('%l:%M %P')
      timmy = (logged_at.strftime('%l%M')).to_i  
     # timmy = (logged_at.in_time_zone('UTC').strftime('%l%M')).to_i   #giving this format 1800 @ #0840 -> 840
      timmy = 1200+timmy if meridian=="pm"
      #note : (below) - previously using 24-hours format
      
      ####override all above--PENDING--temporary fixed - wont work if staff OT & went back after 12.00 midnight
      timmy = (logged_at.strftime('%H%M')).to_i - 8   #1504   -- whereby ending_shift= 1800,           1726 -- whereby ending_shift=1730
      timmy_jam=logged_at.strftime('%H').to_i - 8      #15                                                                  17
      ####
      
      if timmy < ending_shift(shift_id_use.to_i) && self.trigger != false #&& timmy2 < 0  #(&& timmy2 < 0)to work with logout at time after 12:00 midnight --> 00:00hrs
          #DO NOT REMOVE YET-below-working one!
          #early = "#{ending_shift} ~ #{timmy}" + " minutes" + "<BR>JAM_SHIFT:#{jam} MINIT_SHIFT:#{minit_shift} MINIT:#{minit}"+"<BR>TIMMYJAM:#{timmy_jam} TIMMYMINUTES:#{timmy_minutes}"
          jam_diff = (jam - timmy_jam)
          minit_diff = (minit - timmy_minutes) 
          #early = (jam_diff.to_s+" hours " if jam_diff>0) + (minit_diff.to_s+" minutes" if minit_diff>0) # +"#{timmy} ~ #{ending_shift} "
          #replace above early with these line : (page 15:http://localhost:3000/staff_attendances?id=2012-10-02)
          #$$$$$$-----------------------------
          if jam_diff > 0 && minit_diff <= 0 
            if minit_diff ==0
              early = "#{jam_diff} hours" 
            else
              early = "#{jam_diff-1} hours #{60-timmy_minutes} minutes"
            end
          elsif jam_diff > 0 && minit_diff > 0 
            if minit_diff==60
              early="#{jam_diff+1} hours"
            else
                early = "#{jam_diff} hours #{minit_diff} minutes"
            end
          elsif minit_diff > 0 && jam_diff <= 0
              early ="#{minit_diff} minutes"
          else 
              early ="" #rescue for punctual
          end

          early
          #$$$$$$-----------------------------
      else
          #TEMPORARY SOLUTION ------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
          if ending_shift(shift_id_use.to_i) == 700 #for cases - without staff_shift
            if timmy < 1700   #use accordingly : (if timmy < 1800) 1700 for shift end at 5pm & 1800 for shift end at 6pm
              jam_diff = (jam - timmy_jam)
              minit_diff = (minit - timmy_minutes)
              if jam_diff > 0 && minit_diff <= 0 
                  early = "#{jam_diff} hours"
              elsif jam_diff > 0 && minit_diff > 0 
                  early = "#{jam_diff} hours #{minit_diff} minutes"
              elsif minit_diff > 0 && jam_diff <= 0
                  early ="#{minit_diff} minutes"
              end
              "QQQQ<font color=red>"+early+"</font>"
            else 
              "-"#"puntual-balik (without staff_shift) #{timmy} #{ending_shift} #{timmy2}" 
            end
             
          else  #for cases - with staff_shift
            "-" #"punctual-balik (with staff_shift) #{timmy} #{ending_shift} #{timmy2}"
          end
          #TEMPORARY SOLUTION ------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      end
    #----------------------start------for logged-out
    end
    
  end
  #--30June2013
  def self.monthly_colour_status(every_month_begin,thumb_id,previous_status)
    @begin_thismonth = every_month_begin 
	  @begin_nextmonth = every_month_begin.to_date.next_month.beginning_of_month.to_s
	  @monthly_non_approved = StaffAttendance.count_non_approved_monthly(thumb_id,@begin_thismonth,@begin_nextmonth).count
	  if previous_status == 1 && @monthly_non_approved >= 3     #current:yellow     #change from 3 to 1 for checking
		    previous_status = 2                                   #turn into green
    elsif previous_status == 2                                #current:green      
		    if @monthly_non_approved >= 2                     #change from 2 to 1 for checking
			    previous_status = 3                                 #turn into red
        elsif @monthly_non_approved == 0 
			    previous_status = 1                                 #turn into yellow
		    end
	  elsif previous_status == 3                                #current:red
		    if @monthly_non_approved == 0 
			    previous_status = 2                                 #turn into green
		    end 						
	  end
	  return previous_status
  end
  #--30June2013
  
  #--30June2013
  def self.set_colour_status(all_dates,thumb_id,previous_status)
    @all_begin_months = [] 
		for dailydate in all_dates
			@all_begin_months << dailydate.in_time_zone('UTC').to_date.beginning_of_month.to_s
		end
		@count_prev_stat_change = 0
		for every_month_begin in @all_begin_months.uniq
			  #every_month_begin.to_date.month
			  @begin_thismonth = every_month_begin 
			  @begin_nextmonth = every_month_begin.to_date.next_month.beginning_of_month.to_s
			  @monthly_non_approved = StaffAttendance.count_non_approved(thumb_id,@begin_thismonth,@begin_nextmonth).count
			  if previous_status == 1 && @monthly_non_approved >= 3 && @count_prev_stat_change == 0            #current:yellow    #change to 1 for checking, original value:3*** re-update after UAT completed on 25th June 2015
				    previous_status = 2        #turn into green
				    @count_prev_stat_change+=1
				    @date_prev_stat = every_month_begin
			  elsif previous_status == 2     #current:green
				    if @monthly_non_approved >= 2 && @count_prev_stat_change == 1 && (every_month_begin.to_date-@date_prev_stat.to_date) >= 28   #change to 1 for checking, original value:2*** re-update after UAT completed on 25th June 2015
					    previous_status = 3      #turn into red
					    @count_prev_stat_change+=1 
					    @date_prev_stat= every_month_begin
				    elsif @monthly_non_approved == 0 && @count_prev_stat_change == 1 && (every_month_begin.to_date-@date_prev_stat.to_date) >= 28 
					    previous_status = 1      #turn into yellow
					    @count_prev_stat_change-=1
					    @date_prev_stat= every_month_begin 
				    end
			  elsif previous_status == 3    #current:red
				    if @monthly_non_approved == 0 && @count_prev_stat_change == 2 && (every_month_begin.to_date-@date_prev_stat.to_date) >= 28 
					    previous_status = 2   #turn into green
					    @count_prev_stat_change-=1 
					    @date_prev_stat= every_month_begin 
				    end 						
			  end 
		  end 
		  return previous_status
  end  
  
  #--27June2013-refer .../monthly_weekly_report.html.erb...thumb_id (array)
  def self.count_non_approved(thumb_id, start_date,end_date)
    where("trigger=? AND is_approved =? AND thumb_id IN (?) AND logged_at>=? AND logged_at<?", true, false, thumb_id, start_date, end_date).order(logged_at: :desc)
  end
  
  #--1July2013.../status.html.erb..thumb_id(1 person)
  def self.count_non_approved_monthly(thumb_id, start_date,end_date)
    where("trigger IS TRUE AND is_approved IS FALSE AND thumb_id =? AND logged_at>=? AND logged_at<?", thumb_id, start_date, end_date).order(logged_at: :desc)
    #find(:all, :conditions => ["trigger=? AND is_approved =? AND thumb_id IN (?) AND logged_at>=? AND logged_at<?", true, false, thumb_id, start_date, end_date], :order => 'logged_at DESC')
    
  end
  
  def number_format(lateearly_string)
    if lateearly_string.include?("hours")
      hours_cnt=lateearly_string.split("hours")[0].to_i
      minutes_cnt=lateearly_string.split("hours")[1].split("minutes")[0].to_i unless (lateearly_string.split("hours")[1]).nil?
      if hours_cnt < 10
        hou="0"+hours_cnt.to_s
      else
        hou=hours_cnt.to_s
      end
      unless (lateearly_string.split("hours")[1]).nil?
        if minutes_cnt < 10
          minn="0"+minutes_cnt.to_s
        else
          minn=minutes_cnt.to_s
        end
      else
        minn="00"
      end
      lateearly_num=hou+":"+minn
    else
      if lateearly_string.include?("minutes")
        hours_cnt=0
        minutes_cnt=lateearly_string.split("minutes")[0].to_i
        if minutes_cnt < 10
          minn="0"+minutes_cnt.to_s
        else
          minn=minutes_cnt.to_s
        end
        lateearly_num="00:"+minn
      else
        lateearly_num=""
      end
    end
    lateearly_num
  end

  def render_colour_status
    (StaffAttendance::ATT_STATUS.find_all{|disp, value| value == attended.att_colour}).map {|disp, value| disp}
  end
  
  def approval_details
    clock_type="IN : " if log_type=="I" || log_type=="I"
    clock_type="OUT : " if log_type=="O" || log_type=="o"
    if is_approved==true
      a=clock_type+(DropDown::TRIGGER_STATUS.find_all{|disp, value| value == status}).map {|disp, value| disp}[0]+"-"+reason
    else
      #this part won't be displayed if leave_taken / travel_outstation exist - in Monthly Details (Perincian Bulanan)-start
      if trigger==true
        if status.nil? || reason==""
          a=clock_type+I18n.t("attendance.fingerprint_incomplete")
        else
          a=clock_type+I18n.t("attendance.pending_approval") if is_approved==nil 
          a=clock_type+I18n.t("attendance.rejected").upcase+" ("+(DropDown::TRIGGER_STATUS.find_all{|disp, value| value == status}).map {|disp, value| disp}[0]+"-"+reason+")" if is_approved==false
        end
      elsif trigger.nil?
        a=clock_type+I18n.t("attendance.not_triggered") 
      elsif trigger==false #IGNORED
        a=""
      end
      #this part won't be displayed if leave_taken / travel_outstation exist - in Monthly Details (Perincian Bulanan)-end
    end
    a
  end
 
  ATT_STATUS = [
         #  Displayed       stored in db
         [ "Yellow",1 ],
         [ "Green",2 ],
         [ "Red",3 ]
   ]
end
