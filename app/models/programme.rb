class Programme < ActiveRecord::Base
  before_save :set_combo_code
  #after_save :copy_topic_topicdetail
  before_destroy :valid_for_removal
  
  has_ancestry :cache_depth => true
  has_many :topic_details, :class_name => 'Topicdetail',:dependent =>:nullify, :foreign_key => 'topic_code'   #31Oct2013
  has_many :weeklytimetables
  has_many :intakes
  has_many :topic_for_weeklytimetable_details, :class_name => 'WeeklytimetableDetail', :foreign_key => 'topic'
  
  attr_accessor :programme_listng, :subject_listing, :topic_listing, :subject_listing2
  
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
  
  def programme_subject
    "#{root.course_type}"+" "+"#{root.name}"+" "+"#{code}"+" "+"#{name} "
  end
  
  def self.programme_names
    Programme.roots.map(&:programme_list)
  end
  
  #use in exam_controller - set_edit_data
  def self.subject_groupbyprogramme
    subjectby_programmelists=Programme.where(course_type: "Subject").group_by{|x|x.root.programme_list}
    @groupped_subject=[]
    subjectby_programmelists.each do |programmelist, subjects|
      pg_subjects=[[I18n.t('helpers.prompt.select_subject'), '']]
      subjects.each{|subject|pg_subjects << [subject.subject_list, subject.id]} 
      @groupped_subject << [programmelist, pg_subjects]
    end
    @groupped_subject
  end
  
  #used somewhere else
  def self.subject_groupbyprogramme2
    subjectby_programmelists=Programme.where(course_type: "Subject").group_by{|x|x.root.programme_list}
    @groupped_subject=[]
    subjectby_programmelists.each do |programmelist, subjects|
      pg_subjects=[[I18n.t('helpers.prompt.select_subject'), '']]
      subjects.each{|subject|pg_subjects << [subject.subject_list]} # [subject.subject_list, subject.id]} 
      @groupped_subject << [programmelist, pg_subjects]
    end
    @groupped_subject
  end
  
  def self.subject_groupbyoneprogramme(progid)
    subjectby_programmelists=Programme.find(progid).descendants.where(course_type: "Subject").group_by{|x|x.root.programme_list}
    @groupped_subject=[]
    subjectby_programmelists.each do |programmelist, subjects|
      pg_subjects=[[I18n.t('helpers.prompt.select_subject'), '']]
      subjects.each{|subject|pg_subjects << [subject.subject_list]} # [subject.subject_list]}
      @groupped_subject << [programmelist, pg_subjects]
    end
    @groupped_subject
  end
  
  #orignal one-start
  def self.subject_groupbyoneprogramme2(progid)
    subjectby_programmelists=Programme.find(progid).descendants.where(course_type: "Subject").group_by{|x|x.root.programme_list}
    @groupped_subject=[]
    subjectby_programmelists.each do |programmelist, subjects|
      pg_subjects=[[I18n.t('helpers.prompt.select_subject'), '']]
      subjects.each{|subject|pg_subjects << [subject.subject_list, subject.id]} # [subject.subject_list]}
      @groupped_subject << [programmelist, pg_subjects]
    end
    @groupped_subject
  end
  #original one-end
  
  def self.subject_groupbycommonsubjects
    common_subjects=Programme.where('course_type=?','Commonsubject').group_by{|x|x.root.programme_list}
    @groupped_subject=[]
    common_subjects.each do |programmelist, subjects|
      pg_subjects=[[I18n.t('helpers.prompt.select_subject'), '']]
      subjects.each{|subject|pg_subjects << [subject.subject_list]}
      @groupped_subject << [programmelist, pg_subjects]
    end
    @groupped_subject
  end
  
  #use in Exam controller - New
  def self.subject_groupbycommonsubjects2
    common_subjects=Programme.where('course_type=?','Commonsubject').group_by{|x|x.root.programme_list}
    @groupped_subject=[]
    common_subjects.each do |programmelist, subjects|
      pg_subjects=[[I18n.t('helpers.prompt.select_subject'), '']]
      subjects.each{|subject|pg_subjects << [subject.subject_list, subject.id]}
      @groupped_subject << [programmelist, pg_subjects]
    end
    @groupped_subject
  end

  def self.subject_names
    Programme.where(course_type: "Subject").map(&:subject_list)
  end
  
  def self.topic_groupbysubject
    topicby_subjectids=Programme.where(course_type: "Topic").group_by{|x|x.ancestry.split("/").last}
    @groupped_topic=[]
    topicby_subjectids.each do |subjectid, topics|
      sb_topics=[[I18n.t('helpers.prompt.select_topic'), '']]
      topics.sort_by{|x|x.code}.each{|topic|sb_topics << [topic.subject_list, topic.id]}  #[topic.subject_list]}
      @groupped_topic << [Programme.find(subjectid).subject_list, sb_topics]
    end
    @groupped_topic
  end
  
  def self.topic_groupbysubject_oneprogramme(progid)
    topicby_subjectids=Programme.find(progid).descendants.where(course_type: "Topic").group_by{|x|x.ancestry.split("/").last}
    @groupped_topic=[]
    topicby_subjectids.each do |subjectid, topics|
      sb_topics=[[I18n.t('helpers.prompt.select_topic'), '']]
      topics.sort_by{|x|x.code}.each{|topic|sb_topics << [topic.subject_list, topic.id]}  #[topic.subject_list]}
      @groupped_topic << [Programme.find(subjectid).subject_list, sb_topics]
    end
    @groupped_topic
  end
  
  #topics under common subjects only
  def self.topic_groupbycommonsubjects
    #topics_ofcommon_subjects=Programme.where('course_type=?','Commonsubject').descendants
    #topicby_subjectids=Programme.find(progid).descendants.where(course_type: "Topic").group_by{|x|x.ancestry.split("/").last}
    common_subjects=Programme.where('course_type=?','Commonsubject')#.pluck(:id)
    @groupped_topic=[]
    common_subjects.each do |csubject|
      sb_topics=[[I18n.t('helpers.prompt.select_topic'), '']]
      topics=csubject.descendants
      topics.sort_by{|x|x.code}.each{|topic|sb_topics << [topic.subject_list, topic.id]}
      @groupped_topic << [csubject.subject_list, sb_topics]
    end
#     topics_ofcommon_subjects.each do |subjectid, topics|
#       sb_topics=[[I18n.t('helpers.prompt.select_topic'), '']]
#       topics.sort_by{|x|x.code}.each{|topic|sb_topics << [topic.subject_list, topic.id]}  #[topic.subject_list]}
#       @groupped_topic << [Programme.find(subjectid).subject_list, sb_topics]
#     end
    @groupped_topic
  end
  
  private
  
    def valid_for_removal
      if weeklytimetables.count > 0 || intakes.count > 0 || topic_for_weeklytimetable_details.count > 0
        return false
      else
        return true
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
