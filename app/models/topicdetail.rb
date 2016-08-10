 class Topicdetail < ActiveRecord::Base
  
  belongs_to :subject_topic, :class_name=>"Programme", :foreign_key => :topic_code
  belongs_to :topic_creator, :class_name=>"Staff", :foreign_key => :prepared_by
  
  has_many :trainingnotes, :dependent => :nullify 
  accepts_nested_attributes_for :trainingnotes, :allow_destroy => true , :reject_if => lambda { |a| a[:title].blank? }
  #:allow_destroy--> what if this newly inserted ...suddenly selected for other lesson_plan.
  
  validates :topic_code, :prepared_by, presence: true
  validates :topic_code, uniqueness: true
  
  attr_accessor :programme_id, :subject_id
  
  #define scope subject
  def self.subject_search(query)
    subjects=Programme.where('(code ILIKE(?) or name ILIKE(?)) and course_type=?', "%#{query}%", "%#{query}%", 'Subject')
    topic_ids=[]
    subjects.each{|x|topic_ids += x.descendants.where(course_type: 'Topic').pluck(:id)}
    where('topic_code IN(?)', topic_ids)
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:subject_search]
  end
  
  def duration_lecture_tutorial_practical
    st=subject_topic
    d=""
    if st.duration
      d+=st.total_duration+" - "
    else
      d+=" - "
    end
    if st.lecture_d
      d+=st.lecture_duration+"  /  "
    else
      d+=" / "
    end
    if st.tutorial_d
     d+=st.tutorial_duration+"  /  "
    else
      d+=" / "
    end
    if st.practical_d
     d+=st.practical_duration
    end
    d  
  end
  
  def semester_subject_topic
    if subject_topic.course_type == "Topic"
      "Sem #{subject_topic.parent.parent.code}"+"-"+"#{subject_topic.parent.code}"+" | "+"#{subject_topic.name}"
    elsif subject_topic.course_type == "Subtopic"
      ">>Sem #{subject_topic.parent.parent.parent.code}"+"-"+"#{subject_topic.parent.parent.code}"+" | "+"#{subject_topic.code} "+"#{subject_topic.name}"
    end
  end
  
end
