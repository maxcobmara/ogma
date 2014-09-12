class Trainingnote < ActiveRecord::Base
  
  # befores, relationships, validations, before logic, validation logic, 
   #controller searches, variables, lists, relationship checking
   
  #before_save :get_topic_id_from_topicdetail#:get_topic_id_from_timetable
  
  #belongs_to :topic
  #belongs_to :timetable
  belongs_to :topicdetail, :foreign_key=> 'topicdetail_id'
  
  #trial section
  has_many :lesson_plan_trainingnotes , :dependent => :nullify #:destroy # --> once trainingnote in topic details removed, lesson_plan_trainingnote's record will be REMOVED
  has_many :lesson_plans, :through => :lesson_plan_trainingnotes
  #trial section
  
  has_attached_file :document,
                    :url => "/assets/notes/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/notes/:id/:style/:basename.:extension"
  validates_attachment_size :document, :less_than => 25.megabytes  
  validates_attachment_content_type :document, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif","text/plain","application/pdf", "application/mspowerpoint","application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.oasis.opendocument.text","application/vnd.oasis.opendocument.presentation"]
  
  #attr_accessor :topic_id

  #to retrieve topic id if notes uploaded from topic detail
  def get_topic_id_from_topicdetail
    #if topicdetail_id #!= nil
      timetable_id = 1 #topicdetail_id#Topicdetail.find(topicdetail_id).topic_code
    #end
  end
  
end