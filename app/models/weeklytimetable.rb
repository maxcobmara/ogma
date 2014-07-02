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
  validate :approved_or_rejected
  
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
