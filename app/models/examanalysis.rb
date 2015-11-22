class Examanalysis < ActiveRecord::Base
  
  validates_presence_of :exam_id, :message => I18n.t('examanalysis.exam_must_exist')
  validates_uniqueness_of :exam_id, :message => I18n.t('examanalysis.exam_must_uniq')
  has_many :examquestionanalyses#, :dependent => :destroy                                                     
  accepts_nested_attributes_for :examquestionanalyses, :reject_if => lambda { |a| a[:examquestion_id].blank? }
  belongs_to :exampaper, :class_name => 'Exam', :foreign_key => 'exam_id'
   
  def self.search2(search)
    if search 
      if search == '0'  #admin
        @examanalyses = Examanalysis.all
      elsif search == '1' #common subject lecturer
        @result_with_common_subjects=[]
        Examanalysis.all.each do |result|
          subject_ids=Examanalysis.get_subjects(result.programme_id, result.semester).map(&:id)
          common_subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
          common_exist=common_subject_ids & subject_ids
          if common_exist.count > 0
           @result_with_common_subjects << result.id
          end
        end
        @examanalyses = Examanalysis.where(id: @result_with_common_subjects)
      else
        subject_ids=Programme.where(id: search).first.descendants.at_depth(2).pluck(:id)
	exam_ids=Exam.where(subject_id: subject_ids).pluck(:id)
        @examanalyses = Examanalysis.where(exam_id: exam_ids)
      end
    end
  end
  
  # define scope
  def self.keyword_search(query)
    subject_ids=Programme.where('name ILIKE(?) OR code ILIKE(?)', "%#{query}%", "%#{query}%").where(course_type: ['Subject', 'Commonsubject']).pluck(:id)
    exam_ids=Exam.where(subject_id: subject_ids).pluck(:id)
    where(exam_id: exam_ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search]
  end
  
  
end