class LessonPlan < ActiveRecord::Base
  
  #hide before_save to pass rspec - requires current_user to work
  before_save :set_to_nil_where_false,:assign_topic_intake_id, :copy_attached_doc_trainingnotes

  belongs_to :lessonplan_owner,   :class_name => 'Staff',                 :foreign_key => 'lecturer'
  belongs_to :lessonplan_creator, :class_name => 'Staff',                 :foreign_key => 'prepared_by'
  belongs_to :lessonplan_intake,  :class_name => 'Intake',               :foreign_key => 'intake_id'
  #belongs_to :lessonplan_topic,   :class_name => 'Programme',      :foreign_key => 'topic'	#refer WeeklytimetableDetail
  belongs_to :endorser,           :class_name => 'Staff',                 :foreign_key => 'endorsed_by'
  belongs_to :schedule_item,      :class_name => 'WeeklytimetableDetail', :foreign_key => 'schedule'
  
  has_many :lessonplan_methodologies, :dependent => :destroy
  accepts_nested_attributes_for :lessonplan_methodologies, :allow_destroy => true#, :reject_if => lambda { |a| a[:start_at].blank? }
  
  #validate :approved_or_rejected, :satisfy_or_notsatisfy
  validates_presence_of :schedule    #hide on 31st October 2013
  
  #trial section------------
  has_many :lesson_plan_trainingnotes
  accepts_nested_attributes_for :lesson_plan_trainingnotes, :allow_destroy => true, :reject_if => lambda {|a| a[:trainingnote_id].blank?}
  has_many :trainingnotes, :through => :lesson_plan_trainingnotes
  accepts_nested_attributes_for :trainingnotes, :reject_if => lambda {|a| a[:topic_id].blank?}
  #trial section-----------
  
  attr_accessor :title, :schedule2

  #---------------------AttachFile------------------------------------------------------------------------
   has_attached_file :data,
                      :url => "/assets/lesson_plans/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/lesson_plans/:id/:style/:basename.:extension"
   validates_attachment_content_type :data, 
                          :content_type => ['application/pdf', 'application/msword','application/msexcel','image/png','text/plain'],
                          :storage => :file_system,
                          :message => "Invalid File Format" 
   validates_attachment_size :data, :less_than => 5.megabytes 
   
  def set_to_nil_where_false
    if is_submitted == true
      self.submitted_on= Date.today
    end
    
    if hod_approved == false
      self.hod_approved_on= nil
    end
    
    if hod_rejected == true && endorsed_by == 25#current_user.staff_id #User.current_user.staff_id
      self.is_submitted = nil
   end
   
   if prepared_by == nil
      self.prepared_by = 107#current_user.staff_id #User.current_user.staff_id
   end
   
   if report_submit == true
      report_submit_on = Date.today
   end   
   
   if report_summary != nil
      self.report_endorsed = true
      self.report_endorsed_on = Date.today
   end  
   
    #--start--3Nov2013-schedule no longer compulsory
    if schedule != nil
      self.lecture_date = WeeklytimetableDetail.find(schedule).get_date_for_lesson_plan
      self.start_time = WeeklytimetableDetail.find(schedule).get_start_time
      self.end_time = WeeklytimetableDetail.find(schedule).get_end_time
    end
    #--end--3Nov2013-schedule no longer compulsory
    
     #if schedule != nil
       #self.topic = WeeklytimetableDetail.find(schedule).topic
    #end   

   end

   def assign_topic_intake_id
     if schedule != nil
         self.topic = WeeklytimetableDetail.find(schedule).topic
         self.intake_id = Weeklytimetable.find(WeeklytimetableDetail.find(schedule).weeklytimetable_id).intake_id
     end
   end
  #---------------------------
   def copy_attached_doc_trainingnotes
     #TO REVISE - once user matched with staff ready
     #current_user = User.find(11)  ##### 
     #current_user = Login.find(11) Maslinda
     if data
         notes_for_lessonplan = Trainingnote.new     
         notes_for_lessonplan.document_file_name = data_file_name
         notes_for_lessonplan.document_content_type = data_content_type
         notes_for_lessonplan.document_file_size = data_file_size
         notes_for_lessonplan.timetable_id = schedule
         notes_for_lessonplan.staff_id = 25 #current_user.staff_id
         notes_for_lessonplan.title = title

         #check if topicdetails for topic of selected schedule really exist 
         #topiccode = WeeklytimetableDetail.find(schedule).topic
         @topicdetail = Topicdetail.find_by_topic_code(topic)#code)
         if @topicdetail != nil 
             notes_for_lessonplan.topicdetail_id = @topicdetail.id #new record
             @topicdetail_id = @topicdetail.id                    #update record
         end 

         #check training note existance for current lesson plan(schedule) (IN TRAININGNOTES TABLE)
         @trainingnote_lessonplan =  Trainingnote.where(timetable_id: schedule).first  #Trainingnote.find_by_timetable_id(schedule)

         #if (new/changed) uploaded file & timetable_id(schedule) not exist[training note NOT EXIST for lesson plan], 
         #==>INSERT NEW note (into trainingnotes table)
         #if training note ALREADY EXIST for lesson plan, 
         #==>UPDATE EXISTING note (in trainingnotes table)

	 if Trainingnote.where('document_file_name=? and timetable_id=?', data_file_name, schedule).count==0
           notes_for_lessonplan.save   
	 elsif Trainingnote.where('document_file_name=? and timetable_id=?', data_file_name, schedule).count>0
	   @trainingnote_lessonplan.update_attributes(:document_file_name=>data_file_name, :document_content_type=>data_content_type,:document_file_size=>data_file_size, :timetable_id=>schedule, :staff_id=>current_user.staff_id, :title=>title,:topicdetail_id=>@topicdetail_id)
         end
     end 
   end
   
  def hods  
      #hod = User.current_user.staff.position.parent
      #approver = Position.find(:all, :select => "staff_id", :conditions => ["id IN (?)", hod]).map(&:staff_id)
      role_kp = Role.find_by_name('Programme Manager')  #must have role as Programme Manager
      staff_with_kprole = Login.joins(:roles).where('role_id=?',role_kp).pluck(:staff_id).compact.uniq
				    #User.joins(:roles).where('role_id=?',role_kp).pluck(:staff_id).compact.uniq
      #programme_name = Programme.roots.map(&:name)    #must be among Academic Staff 
      #approver = Staff.find(:all, :joins=>:position, :conditions=>['unit IN(?) AND staff_id IN(?)', programme_name, staff_with_kprole])
      current_user = Login.first #User.find(11) #####
      programme_name = current_user.staff.positions[0].unit
      if Programme.roots.pluck(:name).include?(programme_name)
	approver = Staff.joins(:positions).where('unit=? AND staff_id IN(?)', programme_name, staff_with_kprole).pluck(:id).uniq
      else
	approver = Staff.where('id IN(?)',staff_with_kprole).pluck(:id).uniq
      end
      approver  
  end
  
  def self.start_end_time(l)
    "#{l.start_meth.strftime('%H:%M') }"+" - "+"#{l.end_meth.strftime('%H:%M %p') }"
  end
  
  def self.start_end_time_in_minutes(l)
    "("+"#{ (((l.end_meth - l.start_meth )/60 ) % 60).to_i }"+" minutes)"
  end
  
end

#
#CREATE TABLE lesson_plans
#(
#  id serial NOT NULL,
#  lecturer integer,
#  intake_id integer,
#  student_qty integer,
#  semester integer,
#  topic integer,
#  lecture_title character varying(255),
#  lecture_date date,
#  start_time time without time zone,
#  end_time time without time zone,
#  reference text,
#  is_submitted boolean,
#  submitted_on date,
#  hod_approved boolean,
#  hod_approved_on date,
#  hod_rejected boolean,
#  hod_rejected_on date,
#  data_file_name character varying(255),
#  data_content_type character varying(255),
#  data_file_size integer,
#  data_updated_ot timestamp without time zone,
#  prerequisites character varying(255),
#  year integer,
#  reason text,
#  prepared_by integer,
#  endorsed_by integer,
#  condition_isgood boolean,
#  condition_isnotgood boolean,
#  condition_desc character varying(255),
#  training_aids text,
#  summary text,
#  total_absent integer,
#  report_submit boolean,
#  report_submit_on date,
#  report_endorsed boolean,
#  report_endorsed_on date,
#  report_summary text,
#  schedule integer,
#  created_at timestamp without time zone,
#  updated_at timestamp without time zone,
#  CONSTRAINT lesson_plans_pkey PRIMARY KEY (id)
#)