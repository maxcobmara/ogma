class StudentDisciplineCase < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  
  before_save :close_if_no_case, :rev_action_type
  before_destroy :check_case_referred_for_counseling
  
  belongs_to :staff, :foreign_key => 'reported_by'
  belongs_to :ketua, :class_name => 'Staff', :foreign_key => 'assigned_to'
  belongs_to :tphep, :class_name => 'Staff', :foreign_key => 'assigned2_to'
  
  belongs_to :location
  belongs_to :student
  belongs_to :cofile, :foreign_key => 'file_id'
  
  has_many :student_counseling_sessions, :foreign_key => 'case_id', :validate => false#, :dependent => :destroy
  accepts_nested_attributes_for :student_counseling_sessions#, :reject_if => lambda { |a| a[:requested_at].blank? }
  
  validates_presence_of :reported_by, :student_id, :status, :infraction_id, :assigned_to
  
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
 
  attr_accessor :action_type2
 
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

  def render_status
    (DropDown::SDCSTATUS.find_all{|disp, value| value == status }).map {|disp, value| disp}.first
  end
    
  def render_infraction
    a=(DropDown::INFRACTION.find_all{|disp, value| value == infraction_id }).map {|disp, value| disp}.first
    a+=" - "+description if infraction_id==4
    a
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
    end
  end
    
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

# == Schema Information
#
# Table name: student_discipline_cases
#
#  action               :text
#  action_type          :string(255)
#  appeal_decision      :text
#  appeal_decision_on   :date
#  appeal_on            :date
#  assigned2_on         :date
#  assigned2_to         :integer
#  assigned_on          :date
#  assigned_to          :integer
#  board_decision       :text
#  board_decision_on    :date
#  board_meeting_on     :date
#  case_created_on      :date
#  closed_at_college_on :date
#  counselor_feedback   :text
#  created_at           :datetime
#  description          :text
#  file_id              :integer
#  id                   :integer          not null, primary key
#  infraction_id        :integer
#  investigation_notes  :text
#  is_innocent          :boolean
#  location_id          :integer
#  other_info           :text
#  reported_by          :integer
#  reported_on          :date
#  sent_to_board_on     :date
#  status               :string(255)
#  student_id           :integer
#  updated_at           :datetime
#
