class StudentDisciplineCase < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  
  before_save :close_if_no_case, :rev_action_type, :set_refferer
  before_destroy :check_case_referred_for_counseling
  
  belongs_to :staff, :foreign_key => 'reported_by'
  belongs_to :ketua, :class_name => 'Staff', :foreign_key => 'assigned_to'
  belongs_to :tphep, :class_name => 'Staff', :foreign_key => 'assigned2_to'
  
  belongs_to :location
  belongs_to :student
  belongs_to :cofile, :foreign_key => 'file_id'
  belongs_to :college
  
  has_many :student_counseling_sessions, :foreign_key => 'case_id', :validate => false#, :dependent => :destroy
  accepts_nested_attributes_for :student_counseling_sessions, :reject_if => lambda { |a| a[:requested_at].blank? }
  
  validates_presence_of :reported_by, :student_id, :status, :infraction_id, :assigned_to, :reported_on
  validates :case_created_on, :investigation_notes, :closed_at_college_on , presence: true, :if => :case_is_closed?
  validates :case_created_on, :investigation_notes, :assigned2_to, :assigned2_on, presence: true, :if => :case_is_referred_to_mentor_counselor?
  validates :other_info, :action, :closed_at_college_on, presence: true, :if => :action_by_mentor_counselor?
  validates :other_info, presence: true, :if => :case_referred_to_comandant?
  validates :action, :closed_at_college_on, presence: true, :if => :action_by_comandant?
  
  #validate :confimed_date
  
  #def validate_end_date_before_start_date
    #if leavenddate && leavestartdate
      #errors.add(:leavenddate, "Your leave must begin before it ends") if leavenddate < leavestartdate || leavestartdate < DateTime.now
    #end
  #end
  
  #attr_accessor :counseling_required
  
  scope :new2, -> { where(status: 'New')}
  scope :opencase, -> { where(status: 'Open')}
  scope :tphep, -> {where(status: 'Refer to TPHEP')}
  scope :bpl, -> {where(status: 'Refer to BPL')}
  scope :closed, -> {where(status: 'Closed')}
  
 FILTERS = [
    {:scope => "all", :label => I18n.t('student.discipline.all')},
    {:scope => "new2",   :label => I18n.t('student.discipline.new2')},                                      #:scope => "new"
    {:scope => "opencase",  :label =>  I18n.t('student.discipline.open')},
    {:scope => "tphep", :label =>  I18n.t('student.discipline.refer_tphep')},
    {:scope => "bpl",   :label =>  I18n.t('student.discipline.refer_bpl')},
    {:scope => "closed",:label => I18n.t('student.discipline.closed')}
  ]  
 
  attr_accessor :action_type2, :is_counselor
 
  def self.sstaff2(u)
     where('reported_by=? OR assigned_to=? OR assigned2_to=?', u,u,u)
  end    
  
  def close_if_no_case
    if action_type == "no_case" || action_type == "advise" #|| action_type == "counseling"
      self.status = "Closed"
    # self.assigned2_to = nil
    #elsif action_type == "counseling"
      #self.assigned2_to = nil
    elsif action_type == "Ref TPHEP"
      self.status = "Refer to TPHEP"
    end
    #if action_type != "Refer to BPL"	#asal
    if action_type != "Ref to BPL"
      self.sent_to_board_on = nil
    else
      self.status = "Refer to BPL"		#baru
    end
    #tumpang - for testing - hide first 22 Dec 2015
#     if Student.find(student_id).course_id == 4
#     	self.assigned_to = Position.find_by_positioncode('1.1.04').staff_id  #self.assigned_to = 69
#     else
#     	
#   	end
  end
  
  def rev_action_type
    if status=="Closed" 
      if action_type2 && (action_type2==1 || action_type2=='1') 
        if  (action_type=="" || action_type==nil)
          self.action_type="counseling"
        else
          self.action_type=action_type+" & counseling"
        end
      end
    elsif status=="Refer to BPL"
      if action_type2 && (action_type2==1 || action_type2=='1') 
        self.action_type=action_type+" & counseling"
      end
    elsif status=="Refer to Counselor" || status=="Refer to Mentor"
      #do nothing - value assigned by radio button & select field.
    elsif status=="Refer to Comandant"
      self.action_type= "Ref Comandant"
    end 
  end
  
  def set_refferer
    if action_type=="Ref Counselor"
      self.assigned2_to=is_counselor
    end
  end
  
  #Validation use
  def case_is_closed?
    status=="Closed" && college.code=="amsas"
  end
  
  def case_is_referred_to_mentor_counselor?
    (status=="Refer to Counselor" || status=="Refer to Mentor") && college.code=="amsas"
  end
  
  def action_by_mentor_counselor?
    status=="Closed" && (action_type=="Ref Counselor" || action_type=="Ref Mentor") && college.code=="amsas"
  end
  
  def case_referred_to_comandant?
    status=="Refer to Comandant"
  end
  
  def action_by_comandant?
    status=="Closed" && (action_type=="Ref Comandant")
  end
    
  #note : status - in English all the time
  def status_workflow
    flow = Array.new
      if status == nil || status.blank?
        flow << [ I18n.t('student.discipline.new2'),"New"]
      #------------
      elsif status == "New"  
        if reported_by == nil || student_id == nil || status == nil || infraction_id == nil || assigned_to == nil
        	flow << [ I18n.t('student.discipline.new2'),"New"]	#special case for 1st time data entry (upon validation-if any of the above field is nil --> stay with 'New' status)
        else
        	flow << [ I18n.t('student.discipline.open'),"Open"]<< [ I18n.t('student.discipline.refer_tphep'), "Refer to TPHEP"] << [ I18n.t('student.discipline.closed'),"Closed"]
        end
      #------------
      #elsif status == "New"	#asal
        #flow << "Open" 		#asal
      #elsif status == "Open"	#asal
      ####elsif status == "New"		#baru  -- jab
        #####flow << "Open" << "Refer to TPHEP" << "Closed" ---jab
      
      elsif status == "Refer to TPHEP"
        #flow << "Refer to TPHEP" << "Refer to BPL" << "Closed"		#asal
        #flow << "Refer to TPHEP" << "Refer to BPL" << "Closed" << "Open"		#baru-24Dec2012
        flow << [ I18n.t('student.discipline.refer_bpl'), "Refer to BPL"] << [ I18n.t('student.discipline.closed'), "Closed"]		#baru
      elsif status == "Refer to BPL"
        flow << [ I18n.t('student.discipline.refer_bpl'), "Refer to BPL"] << [ I18n.t('student.discipline.new2'),"New"]
      else
    end
    flow
  end

  def status_workflow_amsas
      flow = Array.new
      if status == nil || status.blank?
        flow << [ I18n.t('student.discipline.new2'),"New"]
      elsif status == "New"  
        if reported_by == nil || student_id == nil || status == nil || infraction_id == nil || assigned_to == nil
          flow << [ I18n.t('student.discipline.new2'),"New"]
        else
          flow << [ I18n.t('student.discipline.open'),"Open"]<< [ I18n.t('student.discipline.refer_mentor'), "Refer to Mentor"] << [ I18n.t('student.discipline.refer_counselor'), "Refer to Counselor"] << [ I18n.t('student.discipline.closed'),"Closed"]
        end
      elsif status == "Open"
        flow << [ I18n.t('student.discipline.open'),"Open"]<< [ I18n.t('student.discipline.refer_mentor'), "Refer to Mentor"] << [ I18n.t('student.discipline.refer_counselor'), "Refer to Counselor"] << [ I18n.t('student.discipline.closed'),"Closed"]
      
      #rescue for Edit (_tab_case_edit --> choosing 'no case'/ Refer to Mentor / Refer to Counselor but below 3/4 fields value not supplied
      elsif (status == "Closed" && (case_created_on.nil? || investigation_notes.nil? || closed_at_college_on.nil?))  || (["Refer to Mentor","Refer to Counselor"].include?(status) && (case_created_on.nil? || investigation_notes.nil? || assigned2_to.nil? || assigned2_on.nil?))
         flow << [ I18n.t('student.discipline.open'),"Open"]<< [ I18n.t('student.discipline.refer_mentor'), "Refer to Mentor"] << [ I18n.t('student.discipline.refer_counselor'), "Refer to Counselor"] << [ I18n.t('student.discipline.closed'),"Closed"]

      elsif status == "Refer to Mentor"
        flow << [I18n.t('student.discipline.refer_comandant'), "Refer to Comandant"] << [ I18n.t('student.discipline.closed'), "Closed"]	
        #flow << [I18n.t('select'), "Select"] << [I18n.t('student.discipline.refer_comandant'), "Refer to Comandant"] << [ I18n.t('student.discipline.closed'), "Closed"]	
      elsif status == "Refer to Counselor"
        flow << [ I18n.t('student.discipline.refer_comandant'), "Refer to Comandant"] << [ I18n.t('student.discipline.closed'),"Closed"]
        #flow << [I18n.t('select'), "Select"] << [ I18n.t('student.discipline.refer_comandant'), "Refer to Comandant"] << [ I18n.t('student.discipline.closed'),"Closed"]
      
      #rescue for Actiontaken (_tab_action_taken_edit_amsas --> choose as Mentor/Counselor, to execute action- evaluate case & action fields are blank
      elsif (status =="Closed" && (other_info.blank? || action.blank?))
        flow << [I18n.t('student.discipline.refer_comandant'), "Refer to Comandant"] << [ I18n.t('student.discipline.closed'), "Closed"]

      elsif status == "Refer to Comandant"
        flow << [ I18n.t('student.discipline.refer_comandant'), "Refer to Comandant"] << [ I18n.t('student.discipline.closed'),"Closed"]
      end
      flow
  end
  
  def render_status
    if college.code=='amsas'
      (StudentDisciplineCase::SDCSTATUS_AMSAS.find_all{|disp, value| value == status }).map {|disp, value| disp}.first
    else
      (StudentDisciplineCase::SDCSTATUS.find_all{|disp, value| value == status }).map {|disp, value| disp}.first
    end
  end
  
  def render_infraction
    a=(DropDown::INFRACTION.find_all{|disp, value| value == infraction_id }).map {|disp, value| disp}.first
    a+=" - "+description if infraction_id==4
    a
  end
  
  def render_action_by
    if closed_at_college_on!=nil
      if action!=nil
        if action_type=="Ref Comandant"
          actioner=I18n.t('student.discipline.comandant')
        elsif action_type=="Ref Counselor"
          actioner=I18n.t('student.discipline.counselor')
        elsif action_type=="Ref Mentor"
          actioner="Mentor"
        end
      end
      if action_type=="no_case"
       actioner= I18n.t('student.discipline.no_case')
      end
    else
      actioner=I18n.t('not_completed')
    end
    actioner
  end
    
  def reporter_details 
    suid = Array(reported_by)
    exists = Staff.all.pluck(:id)
    checker = suid & exists
    if reported_by == nil
       "" 
    elsif checker == []
      "Staff No Longer Exists" 
    else
      staff.mykad_with_staff_name
    end
  end
    
  def student_name
    student.blank? ? "Student No Longer Exists" : " #{student.formatted_mykad_and_student_name}" 
  end
    
  def file_name
    cofile.blank? ? "Not Assigned" : " #{cofile.name}"  
  end
    
  def room_no
    location.blank? ? "Not Assigned" : " #{location.location_list}"  
  end
  
  #def self.display_msg(err)
    #full_msg=[]
    #err.each do |k,v|
      #full_msg << v
    #end
    #full_msg
  #end
   
  SDCSTATUS = [
         #  Displayed       stored in db
         [ I18n.t('student.discipline.new2'),"New" ],
         [ I18n.t('student.discipline.open'),"Open" ],
         [ I18n.t('student.discipline.no_case'),"No Case" ],
         [ I18n.t('student.discipline.closed'), "Closed" ],
         [ I18n.t('student.discipline.refer_bpl'), "Refer to BPL" ],   
         [ I18n.t('student.discipline.refer_tphep'), "Refer to TPHEP"]
    ]
  
  SDCSTATUS_AMSAS = [
         #  Displayed       stored in db
         [ I18n.t('student.discipline.new2'),"New" ],
         [ I18n.t('student.discipline.open'),"Open" ],
         [ I18n.t('student.discipline.no_case'),"No Case" ],
         [ I18n.t('student.discipline.closed'), "Closed" ],
         [ I18n.t('student.discipline.refer_counselor'), "Refer to Counselor" ],   
         [ I18n.t('student.discipline.refer_mentor'), "Refer to Mentor" ],   
         [ I18n.t('student.discipline.refer_comandant'), "Refer to Comandant"]
    ]
     
  private
    
    def check_case_referred_for_counseling
      counseling_sessions=StudentCounselingSession.where(case_id: id)
      if counseling_sessions && counseling_sessions.count > 0
        #errors.add(:base, I18n.t('student.discipline.removal_prohibited_for_referred_case'))
        return false
      else
        return true
      end
    end
    
end
