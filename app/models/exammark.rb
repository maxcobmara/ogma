class Exammark < ActiveRecord::Base
  belongs_to :exampaper, :class_name =>'Exam', :foreign_key => 'exam_id'
  belongs_to :studentmark, :class_name => 'Student', :foreign_key => 'student_id'
  has_many :marks, :dependent => :destroy                                                     
  accepts_nested_attributes_for :marks#, :reject_if => lambda { |a| a[:mark].blank? }   #use of validates_presence_of in mark model
  
  before_save :set_total_mcq
  after_save :apply_final_exam_into_grade 
  validates_presence_of   :student_id, :exam_id
  validates_uniqueness_of :student_id, :scope => :exam_id, :message => " - Mark of this exam for selected student already exist. Please edit/delete existing mark accordingly."
  
  attr_accessor :total_marks, :subject_id, :intake_id,:trial1,:trial2, :total_marks_view, :trial3, :total_mcq_in_exammark_single, :trial4, :newrecord_type
  
  # define scope
  def self.keyword_search(query)
    student_ids = Student.where('name ILIKE(?) or matrixno ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id)
    where('student_id IN(?)', student_ids)
  end
  
  def self.totalmarks_search(query)
    exammarks_ids=[]
    Exammark.all.pluck(:id).each do |emid|
      exammarks_ids << emid if Exammark.where(id: emid).first.total_marks.to_f==query.to_f
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
           unless y.student_mark.nil?
             @sum_mcq +=y.student_mark
           else
             @sum_mcq+=0
           end
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

  #14March2013 - rev 17June2013 - rev 30Nov14
  def self.set_intake_group(examyear,exammonth,semester,cuser)    #semester refers to semester of selected subject - subject taken by student of semester???
    @unit_dept = cuser.userable.positions.first.unit

     #if exammonth.to_i <= 7
     if (@unit_dept && @unit_dept == "Kebidanan" && exammonth.to_i <= 9) || (@unit_dept && @unit_dept != "Kebidanan" && exammonth.to_i <= 7)                                                  # for 1st semester-month: Jan-July, exam should be between Feb-July
        @current_sem = 1 
        @current_year = examyear 
        if (semester.to_i-1) % 2 == 0                                                                                 # modulus-no balance
          @intake_year = @current_year.to_i-((semester.to_i-1)/2) 
          @intake_sem = @current_sem 
        elsif (semester.to_i-1) % 2 != 0                                                                             # modulus-with balance
          #29June2013-@intake_year = @current_year.to_i-((semester.to_i+1)%2)           #@intake_year = @current_year.to_i-((semester.to_i+1)%2) --> giving error : 2043/2
          #29June2013-------------------OK
          if (semester.to_i+1)/2 > 3  
            @intake_year = @current_year.to_i-((semester.to_i+1)%2)-2
          elsif (semester.to_i+1)/2 > 2
            @intake_year = @current_year.to_i-((semester.to_i+1)%2)-1
          elsif (semester.to_i+1)/2 > 1
            @intake_year = @current_year.to_i-((semester.to_i+1)%2)
          end  
          #29June2013-------------------
          @intake_sem = @current_sem + 1 
        end 
     elsif (@unit_dept && @unit_dept == "Kebidanan" && exammonth.to_i > 9) || (@unit_dept && @unit_dept != "Kebidanan" && exammonth.to_i > 7)                                                  # 2nd semester starts on July-Dec- exam should be between August-Dec
     #elsif exammonth.to_i > 7
        @current_sem = 2 
        @current_year = examyear
        if (semester.to_i-1) % 2 == 0  
          @intake_year = @current_year.to_i-((semester.to_i-1)/2).to_i
          @intake_sem = @current_sem 
        elsif (semester.to_i-1) % 2 != 0                                                                             # modulus-with balance
          #29June2013-@intake_year = @current_year.to_i-((semester.to_i-1)%2).to_i      # (hasil bahagi bukan baki..)..cth semester 6 
           #29June2013-------------------
            if (semester.to_i+1)/2 > 3  
              @intake_year = @current_year.to_i-((semester.to_i+1)%2)-2
            elsif (semester.to_i+1)/2 > 2
              @intake_year = @current_year.to_i-((semester.to_i+1)%2)-1
            elsif (semester.to_i+1)/2 > 1
              @intake_year = @current_year.to_i-((semester.to_i+1)%2)
            end  
            #29June2013-------------------
          @intake_sem = @current_sem - 1
        end 
     end
     #return @intake_sem.to_s+'/'+@intake_year.to_s   #giving this format -->  2/2012  --> previously done on examresult(2012)

     if @intake_sem == 1 
       @intake_month = '03' if @unit_dept && @unit_dept == "Kebidanan"
       @intake_month = '01' if @unit_dept && @unit_dept != "Kebidanan"
     elsif @intake_sem == 2
       @intake_month = '09' if @unit_dept && @unit_dept == "Kebidanan"
       @intake_month = '07' if @unit_dept && @unit_dept != "Kebidanan"
     end

     return @intake_year.to_s+'-'+@intake_month+'-01'  #giving this format -->  2/2012
  end
  #14March2013
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    if search 
      if search == '0'
        @exammarks = Exammark.all.order(:exam_id)
      elsif search == '1'
         exampapers = Exam.where("subject_id IN (?)", common_subject).pluck(:id)
        @exammarks = Exammark.where("exam_id IN (?)", exampapers).order(:exam_id)
      else
        subject_of_programme = Programme.find(search).descendants.at_depth(2).map(&:id)
        #@exams = Exam.find(:all, :conditions => ["subject_id IN (?) and subject_id NOT IN (?)", subject_of_program, common_subject])
        exampapers = Exam.where('subject_id IN(?) AND subject_id NOT IN(?)',subject_of_programme, common_subject).pluck(:id)
        @exammarks = Exammark.where("exam_id IN (?)", exampapers).order(:exam_id)
      end
    else
       @exammarks = Exammark.all.order(:exam_id)
    end
    #ABOVE : order(:exam_id) - added, when group by exam_id(exampaper), records won't split up - continuous in paging
  end
  
  def self.fullmarks(exam_id)
    @istemplate = Exam.find(exam_id).klass_id
    if @istemplate == 0 
      fullmarks = Exam.find(exam_id).set_full_marks #examtemplates.map(&:total_marks).inject{|sum,x|sum+x}
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
          @grade_to_update.exam1marks = total_marks.to_f/fullmarks.to_f*100
          @grade_to_update.summative = total_marks.to_f/fullmarks.to_f*100*0.70
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
  
  def self.get_valid_exams
    #previous approach
#     e_full_ids=Exam.where(klass_id: 1).pluck(:id)
#     e_w_exist_questions_ids = Exam.joins(:examquestions).where('exam_id IN(?)',e_full_ids).pluck(:exam_id).uniq
#     e_template_ids=Exam.where(klass_id: 0).pluck(:id)
#     e_w_exist_templates_ids = Examtemplate.where('exam_id IN(?)', e_template_ids).pluck(:exam_id).uniq
#     return e_w_exist_questions_ids+e_w_exist_templates_ids 
    valid_exams=[]
    Exam.all.each{|x|valid_exams << x.id if x.complete_paper==true}
    valid_exams
  end
  
  def get_questions_count(examid)
    is_template = Exam.where(id: examid).first.klass_id
    if is_template==1
      questions_count = Examquestion.joins(:exams).where('exam_id=? and questiontype!=?', examid, "MCQ").count
                                    #Exam.where(id: examid).first.examquestions.count
    elsif is_template==0
#       qty_ary = Exam.where(id: examid).first.examtemplates.pluck(:quantity) 
#       group_qty = qty_ary-[qty_ary[0]]
#       questions_count = group_qty.sum  #total questions other than MCQ type
      exam_template=Exam.find(examid).exam_template
      questions_count=0
      exam_template.question_count.each{|k,v|questions_count+=v['count'].to_i if k!="mcq" && (v['count']!='' || v['count']!=nil)}
#       exam_template.question_count.each do |k, v|
#         if v['count']!='' || v['count']!=nil #&& v['weight']!=''                          
#           qty=(v['count']).to_i
#           if k=="mcq"
#             @mcqcount=qty
#           elsif k=="meq"
#             @meqcount=qty
#           elsif k=="seq" 
#             @seqcount=qty
#           elsif k=="acq"
#             @acqcount=qty 
#           elsif k=="osci"
#             @oscicount=qty
#           elsif k=="oscii"
#             @osciicount=qty
#           elsif k=="osce"
#             @oscecount=qty
#           elsif k=="ospe"
#             @ospecount=qty
#           elsif k=="viva"
#             @oscicount=qty
#           end
#         end
#       end
    end
    questions_count
  end
  
end
