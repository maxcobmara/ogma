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
  
  def set_total_mcq
    if total_mcq==nil   #5June2013-added-calculate here if not assign in _view_marks_form(otal_mcq==nil)
      count=0
      @examquestions = Exam.where(id: exam_id).first.examquestions
      @examquestions.each do |x|
         if x.questiontype=="MCQ"
           count+=1
         end
      end
      @allmarks = Mark.where(exammark_id: self.id)
      @sum_mcq = 0
      @allmarks.each_with_index do |y, index|
         if index< count
           @sum_mcq +=y.student_mark
         end
      end
      if self.total_mcq != 0 && @sum_mcq == 0     #in case - only total MCQ entered instead of entering each of MCQ marks
      else
        self.total_mcq = @sum_mcq       
      end
    end               #5June2013-added-calculate here if not assign in _view_marks_form(otal_mcq==nil)
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
  
  def self.fullmarks(exam_id)
    @istemplate = Exam.find(exam_id).klass_id
    if @istemplate == 0 
      fullmarks = Exam.find(exam_id).examtemplates.map(&:total_marks).inject{|sum,x|sum+x}
    else
      fullmarks = Exam.find(exam_id).examquestions.map(&:marks).to_a.inject{|sum,x|sum+x}
    end
    fullmarks
  end
  
  #11June2013---updated 23June2013
  def apply_final_exam_into_grade
    @subject_id = Exam.find(exam_id).subject_id
    @examtype = Exam.find(exam_id).name
    fullmarks = Exammark.fullmarks(exam_id)
    @grade_to_update = Grade.where('student_id=? and subject_id=?', student_id, @subject_id).first
    #@credit_hour=Programme.find(@subject_id).credits.to_i
    
    unless @grade_to_update.nil? || @grade_to_update.blank?
        #if @credit_hour == 3
          # if marks entered not in weightage marks, eg, weightage : mcq=40%(40 que), seq=30%(4 que=40marks), but marks were entered according to actual total marks : 80/80 (but weightage 70%) 
          # TEMPORARY use these FORMULA --> total_marks.to_f/0.9,total_marks.to_f/0.7,total_marks.to_f/1.2  .....OR ELSE
          
          #------if marks entered already in weightage,...exam1marks = total_marks---------------------------------
          @grade_to_update.exam1marks = total_marks.to_f
          @grade_to_update.summative = total_marks.to_f/fullmarks.to_f*70 #REQUIRES FORMULA HERE --> SEE ABOVE EXAMPLE ...LINE 76
          #------------------------------use ABOVE formula for all conditions--HIDE ALL @credit_hour statement-----
          
	        #@grade_to_update.exam1marks = total_marks.to_f/0.9        #depends on weightage 
	        #@grade_to_update.summative = total_marks.to_f/0.9*0.7
        #elsif @credit_hour == 4
          #@grade_to_update.exam1marks = total_marks.to_f/1.2        #depends on weightage
          #@grade_to_update.summative = total_marks.to_f/1.2*0.7
        #elsif @credit_hour == 2
          #@grade_to_update.exam1marks = total_marks.to_f/0.7        #depends on weightage
          #@grade_to_update.summative = total_marks.to_f/0.7*0.7
        #else
          #@grade_to_update.exam1marks = total_marks.to_f            #depends on weightage
          #@grade_to_update.summative = total_marks.to_f*0.7
        #end
        @grade_to_update.save if @grade_to_update.exam1marks && @examtype == "F"  #F for Peperiksaan Akhir Semester
    end
  end
  #11June2013------updated 23June2013
  
end
