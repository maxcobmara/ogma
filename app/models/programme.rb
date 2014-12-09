class Programme < ActiveRecord::Base
  before_save :set_combo_code
  #after_save :copy_topic_topicdetail
  
  has_ancestry :cache_depth => true
  has_many :topic_details, :class_name => 'Topicdetail',:dependent =>:nullify, :foreign_key => 'topic_code'   #31Oct2013
 
  validates_uniqueness_of :combo_code

  #scope :by_semester, -> { where(course_type: 'Semester')}
  def code2
    code.to_i
  end
  
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    else
      self.combo_code = parent.combo_code + "-" + code
    end
  end
  
  def tree_nd
    if is_root?
      gls = ""
    else
      gls = "class=\"child-of-node-#{parent_id}\""
    end
    gls
  end
  
  def subject_list
      "#{code}" + " " + "#{name}"   
  end
  
  def programme_list
    if is_root?
      "#{course_type}" + " " + "#{name}"   
    else
    end
  end
  
  def semester_subject_topic
    if ancestry_depth == 3
      "Sem #{parent.parent.code}"+"-"+"#{parent.code}"+" | "+"#{name}"
    elsif ancestry_depth == 4
      ">>Sem #{parent.parent.parent.code}"+"-"+"#{parent.parent.code}"+" | "+"#{code} "+"#{name}"
    end
  end
  
  
  def subject_with_topic  #use in lesson plan
    "#{parent.code}"+" - "+"#{name}"
  end
  
  def full_parent
    "#{parent.code}"+" - "+"#{parent.name}"
  end
  
  def programme_coursetype_name
     "#{root.course_type}"+" "+"#{root.name}"
  end
  
  def code_course_type_name  #for subject, topic & subtopic in Tree View
    "#{code} #{course_type} #{name}"
  end
  
  def copy_topic_topicdetail
    @topiccode_in_topic_detail = Topicdetail.all.map(&:topic_code)
    #if (course_type=='Topic' || course_type=='Subtopic') && @topiccode_in_topic_detail.include?(id) == false
    if (ancestry_depth == 3 || ancestry_depth == 4) && @topiccode_in_topic_detail.include?(id) == false   #5thOct2013
      @newtopicdetail = Topicdetail.new
      @newtopicdetail.topic_code = id
      if duration==''|| duration.nil? == true             #3thNov2013
        @newtopicdetail.duration = '0'                    #3thNov2013
      else                                                #3thNov2013
        @newtopicdetail.duration = duration.to_s #Time.now  #5thOct2013   
      end                                                 #3thNov2013
      @newtopicdetail.theory = '0'#Time.now               #5thOct2013
      @newtopicdetail.tutorial = '0'#Time.now             #5thOct2013
      @newtopicdetail.practical = '0'#Time.now            #5thOct2013
      @newtopicdetail.prepared_by = User.current_user.staff_id
      @newtopicdetail.save
    end  
  end
    
end

# == Schema Information
#
# Table name: programmes
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  course_type    :string(255)
#  created_at     :datetime
#  credits        :integer
#  duration       :integer
#  duration_type  :integer
#  id             :integer          not null, primary key
#  name           :string(255)
#  objective      :text
#  status         :integer
#  updated_at     :datetime
#
