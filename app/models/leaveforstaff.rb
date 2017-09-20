class Leaveforstaff < ActiveRecord::Base
    include EventsHelper
  
    paginates_per 10  
  
    before_save :save_my_approvers, :save_duration

    belongs_to :applicant,    :class_name => 'Staff', :foreign_key => 'staff_id'
    belongs_to :replacement,  :class_name => 'Staff', :foreign_key => 'replacement_id'
    belongs_to :seconder,     :class_name => 'Staff', :foreign_key => 'approval1_id'
    belongs_to :approver,     :class_name => 'Staff', :foreign_key => 'approval2_id'
    belongs_to :college, :foreign_key => 'college_id'
  
    validates_presence_of :staff_id, :leavetype
    validate :validate_positions_exist
    validate :validate_end_date_before_start_date, :validate_leave_application_is_unique
  
    scope :current_leaves, -> {where('leavestartdate >?', Date.today)}
    
    # NOTE - 19Sept2017 - valid_staffs (staff.rb) already restrict staff w/o valid position fr being displayed (just 2 cater 4 prev existg record)
    def validate_positions_exist
      if !staff_id.blank? && applicant.position_for_staff == "-"
        errors.add(:position,I18n.t('must_exist'))
      end
    end
    
    def validate_end_date_before_start_date
      if leavenddate && leavestartdate && leavetype!=2
        errors.add(:base, I18n.t('staff_leave.begin_before_ends')) if leavenddate < leavestartdate || leavestartdate < DateTime.now
      end
    end
    
    def validate_leave_application_is_unique
      #existing leave
      leavedays = Leaveforstaff.where(staff_id: applicant)
      e_leavedates = []
      leavedays.each do |leave|
        currdate = leave.leavestartdate
        daycount= leave.leavenddate+1-leave.leavestartdate
        0.upto(daycount-1) do |t|
          if currdate <= leave.leavenddate 
            e_leavedates << currdate
            currdate+=1.days
          end
        end
      end
      #current application 
      if leavenddate && leavestartdate
        c_leavedates = []
        c_currdate = leavestartdate
        c_daycount=leavenddate+1-leavestartdate
        0.upto(c_daycount-1) do |u|
          if c_currdate  <= leavenddate
            c_leavedates << c_currdate
            c_currdate+=1.days
          end
        end
        duplicates = (e_leavedates & c_leavedates).count
        if duplicates > 0 && (id.nil? || id.blank?)
          errors.add(:base, I18n.t('staff_leave.leave_already_taken'))
          return false
        else
          return true
        end
      else
        errors.add(:base, I18n.t('staff_leave.start_end_must_exist'))
	return false
      end
      #current
    end
  
    def moo
      User.current_user.staff_id unless User.current_user.staff_id.blank?
    end
  
    #named_scope :relevant,    :conditions =>  ["staff_id=? OR approval1_id=? OR approval2_id=?", User.current_user.staff_id, User.current_user.staff_id, User.current_user.staff_id]
    #named_scope :mine,        :conditions =>  ["staff_id=?", User.current_user[:staff_id]]
    #named_scope :forsupport,  :conditions =>  ["approval1_id=? AND approval1 IS ?", User.current_user.staff_id, nil]
    #named_scope :forapprove,  :conditions =>  ["approval2_id=? AND approver2 IS ? AND approval1=?", User.current_user.staff_id, nil, true]
  
    def self.sstaff2(u)
      where('staff_id=? OR approval1_id=? OR approval2_id=?', u,u,u)
    end
    
    def save_duration
      self.leavedays=leave_for
    end
  
    def save_my_approvers
      if applicant.positions.nil?
      else
        college_code=College.where(id: college_id).first.code
        if approval1_id == nil
          if college_code=='kskbjb'
            self.approval1_id = set_approver1
          else
	    if applicant.positions.count > 0 #==1
              self.approval1_id = set_approver1_default
              #temporary set default value as true if superior not exist
              if set_approver1_default==nil
                self.approval1=true
                self.approval1date=Date.today
              end
            end
          end
        end
        if approval2_id == nil
          if college_code=='kskbjb'
            self.approval2_id = set_approver2
          else
	    if applicant.positions.count > 0 #==1
              self.approval2_id = set_approver2_default
	    end
          end
        end
      end
    end
    
    #Multi positions
    def approver1_list_multipost
      parent_post_ids=applicant.positions.map(&:parent_id)
      parent_staff_ids=Position.valid_posts.where(id: parent_post_ids).pluck(:staff_id)
    end
    
    def approver2_list_multipost
      parent_post_ids=applicant.positions.map(&:parent_id)
      grandparent_post_ids=Position.where(id: parent_post_ids).map(&:parent_id)
      grandparent_staff_ids=Position.valid_posts.where(id: grandparent_post_ids).pluck(:staff_id)
    end
    
    def set_approver1_default
      if applicant.valid_positions.first.parent.staff_id == []
        approver1 = nil
      else
        approver1 = applicant.valid_positions.first.parent.staff_id
      end    
    end
    
    def set_approver2_default
      if applicant.valid_positions.first.parent.is_root?
        approver2 = 0
      else
        # TODO - confirm with user
        approver2 = applicant.valid_positions.first.parent.parent.staff_id
      end
    end 
      
    def set_approver1
#       if applicant.positions.first.parent.staff.id == []
#         approver1 = nil
#       else
#         approver1 = applicant.positions.first.parent.staff.id
#       end    
      #---------------------------
      #temp: remove 'Ketua Teras' from Task & Responsibilities if not required+Ketua Teras part(below)
    
      applicant_unit = applicant.positions.first.unit
      applicant_grade = applicant.staffgrade.name[-2,2]
      unit_members=Position.joins(:staff).where('unit=? and positions.name!=?', applicant_unit, "ICMS Vendor Admin").order(ancestry_depth: :asc)
    
      if Programme.roots.map(&:name).include?(applicant_unit)
        #Academician--start---
        highest_rank = unit_members.sort_by{|x|x.staffgrade.name[-2,2]}.last
        highest_grade = highest_rank.staffgrade.name[-2,2]
        maintasks = applicant.positions.first.tasks_main  
        if maintasks.include?("Ketua Program") 
          approver1 =  Position.where('name=?', "Timbalan Pengarah Akademik (Pengajar)").first.staff_id
        elsif maintasks.include?("Ketua Teras")
	  if highest_grade > applicant_grade #kp exist
	    approver1 = highest_rank.staff_id 
	  else #kp not exist - die ketua prog (tanggung tugas)
	    approver1 =  Position.where('name=?', "Timbalan Pengarah Akademik (Pengajar)").first.staff_id
	  end
        else #pengajar
          app=0
	  kt_id=[]
	  unit_members.each do |u|
            if u.tasks_main.include?("Ketua Teras")
	      app+=1
	      kt_id<< u.id
	    elsif u.tasks_main.include?("Ketua Program")
	      app+=1
	    end
	  end
	  if app==1
	    approver1 = highest_rank.staff_id
	  elsif app==2
	    approver1 = Position.find(kt_id[0]).staff_id
	  end
        end
        #Academician--end---
      
      elsif ["Teknologi Maklumat", "Perpustakaan", "Kewangan & Akaun", "Sumber Manusia"].include?(applicant_unit) || applicant_unit.include?("logistik") || applicant_unit.include?("perkhidmatan")
        #Administration--start--
        highest_rank = unit_members.sort_by{|x|x.staffgrade.name[-2,2]}.last
        highest_grade = highest_rank.staffgrade.name[-2,2]
        if highest_grade > applicant_grade #staffs
          approver1 = highest_rank.staff_id
        elsif highest_grade == applicant_grade #Ketua Unit
          approver1 =  applicant.positions.first.parent.staff_id
        end
        #Administration--end---
    
      elsif ["Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor"].include?(applicant_unit)
        approver1 = Position.where('unit=?', "Pentadbiran").first.staff_id

      elsif applicant_unit == "Pengurusan Tertinggi"
        if applicant.positions.first.name=="Pengarah"
          approver1=nil
        else
          approver1=Position.where('name=?', "Pengarah").first.staff_id
        end
      
      else
        #Administration2--start---
        if applicant.positions.first.parent.staff.id == []
          approver1 = nil
        else
          approver1 = applicant.positions.first.parent.staff.id   #if pentadbiran OK - applicant.positions.first.unit=="Pentadbiran"
        end
        #Administration2--end---
      end
      #-----------------------------------
    end

    def set_approver2
#       if applicant.positions.first.parent.is_root?
#         approver2 = 0
#       else
#         approver2 = applicant.positions.first.parent.parent.staff.id
#       end
      #----------
      applicant_unit = applicant.positions.first.unit
      applicant_grade = applicant.staffgrade.name[-2,2]
      unit_members=Position.joins(:staff).where('unit=? and positions.name!=?', applicant_unit, "ICMS Vendor Admin").order(ancestry_depth: :asc)
      if Programme.roots.map(&:name).include?(applicant_unit)
        #Academician--start---
        highest_rank = unit_members.sort_by{|x|x.staffgrade.name[-2,2]}.last
        highest_grade = highest_rank.staffgrade.name[-2,2]
        maintasks = applicant.positions.first.tasks_main  
        if maintasks.include?("Ketua Program") 
          approver2 =  Position.where('name=?', "Pengarah").first.staff_id
        elsif maintasks.include?("Ketua Teras")
	  if highest_grade > applicant_grade #kp exist
	    approver2 = Position.where('name=?', "Timbalan Pengarah Akademik (Pengajar)").first.staff_id
	  else #kp not exist - die ketua prog (tanggung tugas)
	    approver2 =  Position.where('name=?', "Pengarah").first.staff_id
          end
        else #pengajar je
	  app=0
	  kt_id=[]
	  unit_members.each do |u|
            if u.tasks_main.include?("Ketua Teras")
	      app+=1
	      kt_id << u.id
	    elsif u.tasks_main.include?("Ketua Program")
	      app+=1
	      kt_id << u.id
	    end
	  end
	  if app==1
	    approver2 = Position.where('name=?', "Timbalan Pengarah Akademik (Pengajar)").first.staff_id
	  elsif app==2
	    approver1 = Position.find(kt_id[0]).staff_id
	  end
        end
        #Academician--end---
      
      elsif ["Teknologi Maklumat", "Perpustakaan", "Kewangan & Akaun", "Sumber Manusia"].include?(applicant_unit) || applicant_unit.include?("logistik") || applicant_unit.include?("perkhidmatan") 
        #Administration--start---
        sapprover1 = Position.find_by_staff_id(approval1_id)  #retrieve position
        highest_rank = unit_members.sort_by{|x|x.staffgrade.name[-2,2]}.last
        highest_grade = highest_rank.staffgrade.name[-2,2]
        if highest_grade > applicant_grade  #staffs
          approver2 = sapprover1.parent.staff_id
        elsif highest_grade == applicant_grade  #ketua unit
          approver2 = Position.where('name=?', "Pengarah").first.staff_id
        end
        #Administration--end---
    
      elsif ["Kejuruteraan", "Pentadbiran Am", "Perhotelan", "Aset & Stor"].include?(applicant_unit)
        sapprover1 = Position.find_by_staff_id(approval1_id)  #retrieve position
        approver2 = sapprover1.parent.staff_id
      elsif applicant_unit == "Pengurusan Tertinggi"
        approver2=0
      else
        #Administration2--start---
        if applicant.positions.first.parent.is_root?
          approver2 = 0
        elsif applicant.positions.first.unit=="Pentadbiran"
	  approver2 = Position.where('name=?', "Pengarah").first.staff_id
        else
          approver2 = applicant.positions.first.parent.parent.staff.id
        end
        #Administration2--end--
      end
      #---------------------
    end
  
    def leave_for
      if leavenddate == 'null' || leavestartdate == 'null' || (leavenddate - leavestartdate) == 0
        1
      else
        ((leavenddate - leavestartdate).to_i) + 1
      end
    end
  
    def show_to_day
      shortmonthname(leavenddate)
    end
  

    def cuti_rehat_entitlement
      getdata = applicant.staffgrade.name
        if getdata == nil
          a = 0
        else
         a = (applicant.staffgrade.name)[-2,4].to_i
        end
      b = Date.today.year - applicant.appointdt.try(:year)
      if a < 21 && b < 10
        20
      elsif a < 21 && b > 10
        25
      elsif a < 31 && b < 10
        25
      elsif a < 31 && b > 10
        30
      elsif a > 30 && b < 10
        30
      else
        35
      end
    end
  
    def leave_balance
      accumulated_leave = 0
      leavedays = Leaveforstaff.where('staff_id=? AND leavetype=?',applicant, 1)
      leavedays.each do |leave|
        accumulated_leave+=(leave.leavenddate+1.day-leave.leavestartdate).to_i
      end
      cuti_rehat_entitlement - accumulated_leave if cuti_rehat_entitlement!=nil
    end
      
    def balance_before
      bal_bef = 0
      leavedays = Leaveforstaff.where('staff_id=? AND leavetype=? and leavestartdate <?',applicant, 1, leavestartdate)
      leavedays.each do |leave|
        bal_bef+=(leave.leavenddate+1-leave.leavestartdate).to_i
      end
      cuti_rehat_entitlement - bal_bef if cuti_rehat_entitlement!=nil
    end
  
    def balance_after
      bal_aft = 0
      leavedays = Leaveforstaff.where('staff_id=? AND leavetype=? and leavestartdate <=?',applicant, 1, leavestartdate)
      leavedays.each do |leave|
        bal_aft+=(leave.leavenddate+1-leave.leavestartdate).to_i
      end
      cuti_rehat_entitlement - bal_aft if cuti_rehat_entitlement!=nil
    end
  
    def endorser
      if approval2_id == 0
        "Not Required"
      else
        approver.staff_with_rank
      end
    end
  
    def repl_staff
      sibpos = applicant.valid_positions.first.sibling_ids
      descpos=applicant.valid_positions.first.descendant_ids
      dept   = applicant.valid_positions.first.unit
      sibs   = Position.where(["id IN (?) AND unit=?" , sibpos,dept]).pluck(:staff_id)
      descs = Position.where("id IN(?) AND unit=?", descpos, dept).pluck(:staff_id)
      applicant = Array(staff_id)
      sibs +descs - applicant
    end
    
    def repl_staff_multipost
      sibpos=Array.new
      dept=Array.new
      descpos=Array.new
      applicant.valid_positions.each{|x|sibpos+=x.sibling_ids}
      applicant.valid_positions.each{|x|descpos+=x.descendant_ids}
      applicant.valid_positions.each{|x|dept << x.unit}
      sibs=Position.where('id IN(?) and unit IN(?)', sibpos, dept).pluck(:staff_id)
      descs=Position.where('id IN(?) and unit IN(?)', descpos, dept).pluck(:staff_id)
      applicant=Array(staff_id)
      sibs + descpos - applicant
    end
  
    def self.leavetype_when_day_taken_off(staffid, details_date) #details_date = checked date
      month_begin=details_date.beginning_of_month
      month_end=details_date.end_of_month
      #leavestaken=Leaveforstaff.where(staff_id: staffid, approval1: true, approver2: true) #shall collect all approved leaves date
      leavestaken=Leaveforstaff.where(staff_id: staffid, approval1: true, approver2: true).where('(leavestartdate >=? and leavestartdate <=?) or (leavenddate >=? and leavenddate <=?)', month_begin, month_end, month_begin, month_end)
      #leaves_dates=[]
      @leave_id=0#"nope"
      leavestaken.each do |lt|
       # leaves_dates << lt.leavestartdate
        duration=lt.leave_for
	adate=lt.leavestartdate
        0.upto(duration-1) do |cnt|
          #leaves_dates << adate+=cnt.days
	  adate+=cnt.days
	  if adate==details_date
	    @leave_id=lt.id  #"hula"+lt.id.to_s
	  end
        end
      end
      #leaves_dates  #collection of leaves date in a given month/year
      @leave_id
      if @leave_id==0
        checkeddate_leavetype=""
      else
        checkeddate_leavetype=(DropDown::STAFFLEAVETYPE.find_all{|disp, value| value == Leaveforstaff.find(@leave_id).leavetype}).map {|disp, value| disp}[0] 
      end
    end
    
    def render_leave_type
      (DropDown::STAFFLEAVETYPE.find_all{|disp, value| value == leavetype}).map {|disp, value| disp} [0]
    end
    
    #usage - mailers/leaveforstaffs_mailer.rb - 20Sept2017
    def final_status
      if approval2_id!=nil
        if @leaveforstaff.approver2 == true
          final=(t 'staff_leave.approved')
        elsif @leaveforstaff.approver2 == false
          final=(t 'staff_leave.rejected')
        end 
      elsif @leaveforstaff.approval2_id==nil 
        if @leaveforstaff.approval1==true
          final=(t 'staff_leave.approved') 
        elsif @leaveforstaff.approval1==false
          final=(t 'staff_leave.rejected') 
        end
      end
      final
    end
 
  end