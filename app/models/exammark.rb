class Exammark < ActiveRecord::Base
  belongs_to :exampaper, :class_name =>'Exam', :foreign_key => 'exam_id'
  belongs_to :studentmark, :class_name => 'Student', :foreign_key => 'student_id'
  has_many :marks, :dependent => :destroy                                                     
  accepts_nested_attributes_for :marks#, :reject_if => lambda { |a| a[:mark].blank? }   #use of validates_presence_of in mark model
  
  before_save :set_total_mcq, :apply_final_exam_into_grade
  validates_presence_of   :student_id, :exam_id
  validates_uniqueness_of :student_id, :scope => :exam_id, :message => " - Mark of this exam for selected student already exist. Please edit/delete existing mark accordingly."
  
  attr_accessor :total_marks, :subject_id, :intake_id,:trial1,:trial2, :total_marks_view, :trial3, :total_mcq_in_exammark_single, :trial4
  
  # define scope
  def self.keyword_search(query)
    student_ids = Student.where('name ILIKE(?) or matrixno ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id)
    where('student_id IN(?)', student_ids)
  end
  
  def self.totalmarks_search(query)
    marksby_exammark = Mark.all.group_by(&:exammark_id)
    exammarks_ids=[]
    marksby_exammark.each do |emid, mms|
      exammarks_ids << emid if Exammark.where(id: emid).first.total_marks==query.to_i
    end
    where('id IN(?)', exammarks_ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search, :totalmarks_search]
  end
  
  def total_marks
    if self.id
      return Mark.where(exammark_id: self.id).sum(:student_mark)+total_mcq.to_i
    else
      @total_marks	#any input by user will be ignored either edit form or new (including re-submission-invalid data)
       #value assigned from partial..(1) single entry(_form.html.erb-line 44-47) (2) multiple entry(_form_by_paper.html.erb-line88-91)
    end
  end

  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    if search 
      if search == '0'
        @exammarks = Exammark.all
      elsif search == '1'
         exampapers = Exam.where("subject_id IN (?)", common_subject).pluck(:id)
        @exammarks = Exammark.where("exam_id IN (?)", exampapers)
      else
        subject_of_programme = Programme.find(search).descendants.at_depth(2).map(&:id)
        #@exams = Exam.find(:all, :conditions => ["subject_id IN (?) and subject_id NOT IN (?)", subject_of_program, common_subject])
        exampapers = Exam.where('subject_id IN(?) AND subject_id NOT IN(?)',subject_of_programme, common_subject).pluck(:id)
        @exammarks = Exammark.where("exam_id IN (?)", exampapers)
      end
    else
       @exammarks = Exammark.all
    end
  end
  
end
