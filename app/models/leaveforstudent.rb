class Leaveforstudent < ActiveRecord::Base
  
  belongs_to :student
  belongs_to :staff
  belongs_to :second_approver, :class_name=>"Staff", :foreign_key=>"staff_id2"

  validates_presence_of :student_id, :leavetype, :leave_startdate, :leave_enddate, :reason, :address
  validates_numericality_of :telno
  validate :validate_kin_exist
  validate :validate_end_date_before_start_date
  validates_presence_of :staff_id, :if => :is_approved?
  validates_presence_of :staffid2, :if => :is_approved2?

  before_save :update_student_college
  
  #scope :pending_coor, -> { where(assettype: 1)}
  
  scope :approved_coordinator, -> { where('studentsubmit=? and approved=?', true, true) }
  scope :approved_warden, -> { where('studentsubmit=? and approved2=?', true, true) }
  scope :pending_coordinator, -> { where('studentsubmit=? and id not in(?)', true, Leaveforstudent.approved_coordinator.map(&:id)) }
  scope :pending_warden, -> { where('studentsubmit=? and id not in(?)', true, Leaveforstudent.approved_warden.map(&:id)) }
  scope :expired_coordinator, -> { where('studentsubmit=? and leave_startdate <? AND (approved is null or approved=?)', true, Date.tomorrow, false)}
  scope :expired_warden, -> { where('studentsubmit=? and leave_startdate <? AND (approved2 is null or approved2=?)', true, Date.tomorrow, false) }

  # define scope
  def self.warden_search(query) 
    if query
      if query=='1'
        ids=Leaveforstudent.approved_warden.pluck(:id)  
      elsif query=='0'
        ids=Leaveforstudent.where(studentsubmit: true, approved2: false).pluck(:id)
      elsif query=='expired'
        ids=Leaveforstudent.expired_warden.pluck(:id)
      elsif query=='valid'
        #ids=Leaveforstudent.where('studentsubmit=? and leave_startdate >=? AND (approved2 is null or approved2=?)', true, Date.tomorrow, false).pluck(:id)
        ids=Leaveforstudent.where('id not IN(?)', Leaveforstudent.expired_warden.pluck(:id)).pluck(:id)
      end
    else
      ids=Leaveforstudent.all.pluck(:id)
    end
    where('id IN(?)', ids)
  end
  
  def self.coordinator_search(query) 
    if query
      if query=='1'
        ids=Leaveforstudent.approved_coordinator.pluck(:id)  
      elsif query=='0'
        ids=Leaveforstudent.where(studentsubmit: true, approved: false).pluck(:id)
      elsif query=='expired'
        ids=Leaveforstudent.expired_coordinator.pluck(:id)
      elsif query=='valid'
        #ids=Leaveforstudent.where('studentsubmit=? and leave_startdate >=? AND (approved is null or approved=?)', true, Date.tomorrow, false).pluck(:id)  
        ids=Leaveforstudent.where('id not IN(?)', Leaveforstudent.expired_coordinator.pluck(:id)).pluck(:id)
      end
    else
      ids=Leaveforstudent.all.pluck(:id)
    end
    where('id IN(?)', ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:warden_search, :coordinator_search]
  end
  ####
  
  def validate_end_date_before_start_date
    if leave_enddate && leave_startdate
      errors.add(:end_date, "Your leave must begin before it ends") if leave_enddate < leave_startdate || leave_startdate < DateTime.now
    end
  end

  def validate_kin_exist
     if student.kins.count < 1
      errors.add( I18n.t('student.leaveforstudent.has_no_kin'), I18n.t('student.leaveforstudent.update_student_kin')) 
     end
  end
  
  def is_approved?
    approved==true
  end
  
  def is_approved2?
    approved2==true
  end
  
  def self.find_main
    Student.find(:all, :condition => ['student_id IS NULL'])
  end
  
  def self.find_main
    Staff.find(:all, :condition => ['staff_id IS NULL'])
  end
  
  def approver_details2
    if staff_id2 == nil
      ""
    else
      second_approver.name
    end
  end

  #<07/10/2011 - Shaliza fixed for error when staff no longer exists>
  def approver_details 
      #suid = staff_id.to_a
      #exists = Staff.find(:all, :select => "id").map(&:id)
      #checker = suid & exists     
  
      if staff_id == nil 
         "" 
         #elsif checker == []
         #"Staff No Longer Exists" 
      else
        staff.name
      end
  end

  #<18/10/2011 - Shaliza fixed for error when student no longer exists>
  def student_details 
      #suid = student_id.to_a
      #exists = Student.find(:all, :select => "id").map(&:id)
      #checker = suid & exists     
  
      if student_id == nil
         "" 
         #elsif checker == []
         #"Student No Longer Exists" 
      else
        student.formatted_mykad_and_student_name
      end
  end
  
  def student_intake
    Intake.where('monthyear_intake=? and programme_id=?', student.intake, student.course_id).first
  end
  
  def group_intake
     if student_intake
       student_intake.group_with_intake_name
     else
       " - ("+I18n.t('student.leaveforstudent.intake')+" : "+student.intake.strftime('%b %Y').to_s+")"
     end
  end
  
  def group_coordinator
    if student_intake
      group_no = student_intake.description
      group_name = "Penyelaras Kumpulan "+group_no
      coordinator = Staff.joins(:positions).where('tasks_main ILIKE (?)',"%#{group_name}%").first
    end
    coordinator
  end
  
  def warden_list
    staff_ids = Login.joins(:roles).where('roles.name=?', "Warden").pluck(:staff_id).compact.uniq
  end
  
  def self.search2(curr_user)
    if curr_user.userable_type=="Student"
      userable_id=curr_user.userable_id
      leaveforstudents = Leaveforstudent.where(student_id: userable_id)
    else
      if curr_user.roles.pluck(:id).include?(2) || curr_user.roles.pluck(:authname).include?("student_leaves_module_admin") || curr_user.roles.pluck(:authname).include?("student_leaves_module_viewer") || curr_user.roles.pluck(:authname).include?("student_leaves_module_user")
        leaveforstudents = Leaveforstudent.all
      else
###
         if curr_user.roles.pluck(:id).include?(7)
           if curr_user.userable.positions.first.tasks_main.include?('Penyelaras Kumpulan')
             leaveforstudents = Leaveforstudent.where('student_id IN(?)', curr_user.under_my_supervision)     
           else
             leaveforstudents = Leaveforstudent.all
           end
         else
           leaveforstudents = Leaveforstudent.where('student_id IN(?)', curr_user.under_my_supervision)  
         end
#       if curr_user.roles.pluck(:id).include?(7)
#         leaveforstudents = Leaveforstudent.all
#       else
#         leaveforstudents = Leaveforstudent.where('student_id IN(?)', curr_user.under_my_supervision)  
#       end
      end
    end
    leaveforstudents
  end
  
  def update_student_college
    self.college_id=student.college_id unless student.college_id.nil?
  end

end