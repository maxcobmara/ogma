class Leaveforstaff < ActiveRecord::Base
  
    paginates_per 10  
  
    before_save :save_my_approvers
  

    belongs_to :applicant,    :class_name => 'Staff', :foreign_key => 'staff_id'
    belongs_to :replacement,  :class_name => 'Staff', :foreign_key => 'replacement_id'
    belongs_to :seconder,     :class_name => 'Staff', :foreign_key => 'approval1_id'
    belongs_to :approver,     :class_name => 'Staff', :foreign_key => 'approval2_id'
  
    validates_presence_of :staff_id, :leavetype
    validate :validate_positions_exist
    validate :validate_end_date_before_start_date
  
    def validate_positions_exist
      if applicant.position_for_staff == "-"
        errors.add(:position, "must exist")
      end
    end
    
    def validate_end_date_before_start_date
      if leavenddate && leavestartdate
        errors.add(:leavenddate, "Your leave must begin before it ends") if leavenddate < leavestartdate || leavestartdate < DateTime.now
      end
    end
  
    def moo
      User.current_user.staff_id unless User.current_user.staff_id.blank?
    end
  
    #named_scope :relevant,    :conditions =>  ["staff_id=? OR approval1_id=? OR approval2_id=?", User.current_user.staff_id, User.current_user.staff_id, User.current_user.staff_id]
    #named_scope :mine,        :conditions =>  ["staff_id=?", User.current_user[:staff_id]]
    #named_scope :forsupport,  :conditions =>  ["approval1_id=? AND approval1 IS ?", User.current_user.staff_id, nil]
    #named_scope :forapprove,  :conditions =>  ["approval2_id=? AND approver2 IS ? AND approval1=?", User.current_user.staff_id, nil, true]

    def self.keyword_search(query) 
      staff_ids = Staff.where('icno ILIKE (?) OR name ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id).uniq
      where('staff_id IN(?)', staff_ids)
    end
    
    def self.ransackable_scopes(auth_object = nil)
      [:keyword_search]
    end
  
  
    def self.find_main
      Staff.find(:all, :condition => ["staff_id=? OR approval1_id=? OR approval2_id=?", User.current_user.staff_id, User.current_user.staff_id, User.current_user.staff_id])
    end
  
    def save_my_approvers
      if applicant.positions.nil?
      else
        if approval1_id == nil
          self.approval1_id = set_approver1
        end
        if approval2_id == nil
          self.approval2_id = set_approver2
        end
      end
    end
  
    def set_approver1
      if applicant.positions.first.parent.staff.id == []
        approver1 = nil
      else
        approver1 = applicant.positions.first.parent.staff.id
      end    
    end
  
    def set_approver2
      if applicant.positions.first.parent.is_root?
        approver2 = 0
      else
        approver2 = applicant.positions.first.parent.parent.staff.id
      end
    end
  
  
  
    def leave_for
      if leavenddate == 'null' || leavestartdate == 'null' || (leavenddate - leavestartdate) == 0
        1
      else
        ((leavenddate - leavestartdate).to_i) + 1
      end
    end
  
    def show_to_day
      if (leavenddate - leavestartdate) == 0
        ""
      else
        ("") + (leavenddate.strftime("%d %b %Y")).to_s
      end
    end
  

    def cuti_rehat_entitlement
      getdata = applicant.staffgrade.name
        if getdata == nil
          a = 0
        else
         a = (applicant.staffgrade.name)[-2,4].to_i
        end
      b = Date.today.year - applicant.appointdt.year
      if    a < 21 && b < 10
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
        accumulated_leave+=leave.leavenddate+1-leave.leavestartdate
      end
      cuti_rehat_entitlement - accumulated_leave
    end
  
  
    def endorser
      if approval2_id == 0
        "Note Required"
      else
        approver.name
      end
    end
  
    def repl_staff
      sibpos = applicant.positions.first.sibling_ids
      dept   = applicant.positions.first.unit
      sibs   = Position.where(["id IN (?) AND unit=?" , sibpos,dept]).pluck(:staff_id)
      applicant = Array(staff_id)
      sibs - applicant
    end
    
    def self.search2(current_user)
      my_first_level_approval  = Leaveforstaff.where(approval1_id: current_user.userable_id).where(approval1: nil)
      my_second_level_approval = Leaveforstaff.where(approval1: true).where(approval2_id: current_user.userable_id).where(approver2: nil)
      my_first_level_approval + my_second_level_approval
    end
  

  end