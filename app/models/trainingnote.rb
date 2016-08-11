class Trainingnote < ActiveRecord::Base
  
  # befores, relationships, validations, before logic, validation logic, 
   #controller searches, variables, lists, relationship checking
   
  #before_save :get_topic_id_from_topicdetail#:get_topic_id_from_timetable
  before_destroy :restrict_when_use_in_lesson_plan
  #belongs_to :topic
  #belongs_to :timetable
  belongs_to :note_creator, :class_name => 'Staff', :foreign_key => :staff_id
  belongs_to :topicdetail, :foreign_key=> 'topicdetail_id'
  
  belongs_to :reference_plan, :class_name => 'LessonPlan', :foreign_key => 'timetable_id'
  #trial section
  has_many :lesson_plan_trainingnotes# , :dependent => :nullify #:destroy # --> once trainingnote in topic details removed, lesson_plan_trainingnote's record will be REMOVED
  has_many :lesson_plans, :through => :lesson_plan_trainingnotes
  #trial section
  
  has_attached_file :document,
                    :url => "/assets/notes/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/notes/:id/:style/:basename.:extension"
  validates_attachment_size :document, :less_than => 25.megabytes  
  validates_attachment_content_type :document, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","text/plain","application/pdf", "application/mspowerpoint","application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.oasis.opendocument.text","application/vnd.oasis.opendocument.presentation"]
  
  #validates :document_file_name, uniqueness: true
  validates :staff_id, presence: true
  #attr_accessor :topic_id

  #to retrieve topic id if notes uploaded from topic detail
  def get_topic_id_from_topicdetail
    #if topicdetail_id #!= nil
      timetable_id = 1 #topicdetail_id#Topicdetail.find(topicdetail_id).topic_code
    #end
  end
  
  def subject_topic2 #subject_topic -> refer relationship line above
    if topicdetail_id!= nil       #view subject code, topic & title of notes
      topic_id = Topicdetail.find(topicdetail_id).topic_code
      if topic_id!=nil   
        ##topic_list = Programme.at_depth(3).map(&:id)
        ##subject_list = Programme.at_depth(2).map(&:id)
        ##subject_id = Programme.find(topic_id).parent.id
        #topic_list=Programme.where(course_type: 'Topic').pluck(:id)
        #subject_list=Programme.where(course_type: 'Subject').pluck(:id)
        #subject_id=Programme.find(topic_id).ancestors.where(course_type: 'Subject').first.id

        topic_rec=Programme.find(topic_id)
        subject_code=topic_rec.ancestors.where(course_type: 'Subject').first.code
        topic_name=topic_rec.name

        ##if topic_list.include?(topic_id)==true && subject_list.include?(subject_id)==true
          #"#{Programme.find(Topicdetail.find(topicdetail_id).topic_code).parent.code}| #{Programme.find(Topicdetail.find(topicdetail_id).topic_code).name} - #{title}"
          "#{subject_code} | #{topic_name} - #{title}"
        ##end
      else
        "#{title}"
      end      
    else
      "#{title}"
    end
  end
  
  #define scope subject
  def self.subject_search(query)
    if query
      sel_programme = Programme.where('(code ILIKE(?) OR name ILIKE(?)) AND course_type=?',"%#{query}%", "%#{query}%", "Subject").first
      if sel_programme!=nil
        topicids=sel_programme.descendants.pluck(:id)
        topicdetailsids = Topicdetail.where('topic_code IN(?)', topicids).pluck(:id)
      else
        topicdetailsids = []
      end
      return Trainingnote.where('topicdetail_id IN(?)', topicdetailsids)
    end
  end
    
  def self.programme_search(query)
    if query
      sel_programme=Programme.where('name ILIKE(?) AND ancestry_depth=?',"%#{query}%",0).first
      if sel_programme!=nil 
        topicids=sel_programme.descendants.at_depth(3).pluck(:id)
        subtopicids=sel_programme.descendants.at_depth(4).pluck(:id)
        topicdetailsids = Topicdetail.where('topic_code IN(?) OR topic_code IN(?)', topicids, subtopicids).pluck(:id)
        return Trainingnote.where('topicdetail_id IN(?)', topicdetailsids)
      else
        topicdetailsids=[]
      end
      return Trainingnote.where('topicdetail_id IN(?)', topicdetailsids)
    end
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:subject_search, :programme_search]
  end
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    #timetable_id exist (note created via lesson plan -->select timetable which consist topic)
    #but if selected topic has no TOPIC DETAIL yet...
    notopicdetail_timetable_exist = Trainingnote.where('topicdetail_id is null AND timetable_id is not null').pluck(:timetable_id)
    topic_timetable_exist_raw = WeeklytimetableDetail.where('id iN(?)', notopicdetail_timetable_exist).pluck(:topic)
    if search 
      if search == '0'
        training_notes = Trainingnote.all
      else
        if search == '1'
          topicids = Programme.where('id IN(?)', common_subject).first.descendants.at_depth(3).pluck(:id)
          subtopicids = Programme.where('id IN(?)', common_subject).first.descendants.at_depth(4).pluck(:id)
        else
          topicids = Programme.where(id: search).first.descendants.at_depth(3).pluck(:id)
          subtopicids = Programme.where(id: search).first.descendants.at_depth(4).pluck(:id)
        end
        topic_timetable_exist = Programme.where('id IN(?) AND (id IN(?) OR id IN(?))', topic_timetable_exist_raw, topicids, subtopicids).pluck(:id)
        timetableids = WeeklytimetableDetail.where('topic IN(?)', topic_timetable_exist).pluck(:id)
        topicdetailsids = Topicdetail.where('topic_code IN(?) OR topic_code IN(?)', topicids, subtopicids).pluck(:id)
        nobody_ownids = Trainingnote.where('timetable_id is null AND topicdetail_id is null').pluck(:id)
        training_notes = Trainingnote.where('topicdetail_id IN(?) OR id IN(?) OR timetable_id IN(?)', topicdetailsids, nobody_ownids, timetableids)
      end
    end
    training_notes
  end
  
  def restrict_when_use_in_lesson_plan
    if timetable_id?
      return false
    else
      return true
    end
  end
  
end