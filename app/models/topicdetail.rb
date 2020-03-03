 class Topicdetail < ActiveRecord::Base
  
  belongs_to :subject_topic, :class_name=>"Programme", :foreign_key => :topic_code
  belongs_to :topic_creator, :class_name=>"Staff", :foreign_key => :prepared_by
  
  has_many :trainingnotes, :dependent => :nullify 
  accepts_nested_attributes_for :trainingnotes, :allow_destroy => true , :reject_if => lambda { |a| a[:title].blank? }
  #:allow_destroy--> what if this newly inserted ...suddenly selected for other lesson_plan.
  
  attr_accessor :programme_id, :subject_id
  
  #define scope subject
  def self.subject_search(query)
    topiccode=Programme.where('code ILIKE(?)',"%#{query}%")[0].descendants.pluck(:id)
    return Topicdetail.where('topic_code IN(?)', topiccode)
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:subject_search]
  end
  
  def duration_lecture_tutorial_practical
    st=subject_topic
    d=""
    if st.duration
      d=duration_d+" - "
    else
      d=" - "
    end
    if st.lecture && st.lecture_time
      d+=lecture_d+"  /  "
    else
      d+=" / "
    end
    if st.tutorial && st.tutorial_time
     d+=tutorial_d+"  /  "
    else
      d+=" / "
    end
    if st.practical && st.practical_time
     d+=practical_d
    end
    d  
  end
  
  def duration_d
    st=subject_topic
    "#{st.duration.try(:strftime, "%H:%M")+I18n.t('training.topicdetail.hours_minutes') }" if st.duration
  end
  
  def lecture_d
    st=subject_topic
    "#{st.lecture} "+"#{(DropDown::LECTURE_TIME.find_all{|disp, value| value == st.lecture_time}).map {|disp, value| disp}[0]}" if st.lecture && st.lecture_time
  end
  
  def tutorial_d
    st=subject_topic
     "#{st.tutorial} "+"#{(DropDown::LECTURE_TIME.find_all{|disp, value| value == st.tutorial_time}).map {|disp, value| disp}[0]}"
  end
  
  def practical_d
    st=subject_topic
    "#{st.practical} "+"#{(DropDown::LECTURE_TIME.find_all{|disp, value| value == st.practical_time}).map {|disp, value| disp}[0]}"
  end
  
  def semester_subject_topic
    if subject_topic.course_type == "Topic"
      "Sem #{subject_topic.parent.parent.code}"+"-"+"#{subject_topic.parent.code}"+" | "+"#{subject_topic.name}"
    elsif subject_topic.course_type == "Subtopic"
      ">>Sem #{subject_topic.parent.parent.parent.code}"+"-"+"#{subject_topic.parent.parent.code}"+" | "+"#{subject_topic.code} "+"#{subject_topic.name}"
    end
  end
  
end

# == Schema Information
#
# Table name: topicdetails
#
#  contents    :text
#  created_at  :datetime
#  duration    :time
#  id          :integer          not null, primary key
#  objctives   :text
#  practical   :time
#  prepared_by :integer
#  theory      :time
#  topic_code  :integer
#  topic_name  :string(255)
#  tutorial    :time
#  updated_at  :datetime
#  version_no  :float
#
