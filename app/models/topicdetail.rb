 class Topicdetail < ActiveRecord::Base
  
  belongs_to :subject_topic, :class_name=>"Programme", :foreign_key => :topic_code
  belongs_to :topic_creator, :class_name=>"Staff", :foreign_key => :prepared_by
  
  has_many :trainingnotes, :dependent => :nullify 
  accepts_nested_attributes_for :trainingnotes, :allow_destroy => true , :reject_if => lambda { |a| a[:title].blank? }
  #:allow_destroy--> what if this newly inserted ...suddenly selected for other lesson_plan.
  
  #define scope subject
  def self.subject_search(query)
    topiccode=Programme.where('code ILIKE(?)',"%#{query}%")[0].descendants.pluck(:id)
    return Topicdetail.where('topic_code IN(?)', topiccode)
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:subject_search]
  end
  
end
