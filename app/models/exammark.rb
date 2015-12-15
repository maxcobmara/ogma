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
    if total_mcq.nil? || total_mcq.blank?
      self.total_mcq=0.0
    end
  end
  
  def total_marks
    diploma=Programme.where(course_type: 'Diploma')
    radiografi=diploma.where('name ILIKE?', '%Radiografi%').first.id
    carakerja=diploma.where('name ILIKE?', '%Jurupulih Perubatan Cara Kerja%').first.id
    ###
     #if !(@exammarks[0].exampaper.subject.root_id==radiografi || @exammarks[0].exampaper.subject.root_id==carakerja) && @exammarks[0].exampaper.name=='F'
    ###
    if exampaper.subject.root_id==radiografi || exampaper.subject.root_id==carakerja
      total=marks.sum(:student_mark)+total_mcq.to_i       #actual total entered by user
    else
      if exampaper.name=='F'
        total=marks.sum(:student_mark)+total_mcq.to_i  
      else
        total=totalsummative    #refer _form_multiple: total marks view shall display total marks entered if weightage not exist, otherwise display total in weightage 
      end
    end
    total
#     if self.id
#       return Mark.where(exammark_id: self.id).sum(:student_mark)+total_mcq.to_i
#     else
#       @total_marks	#any input by user will be ignored either edit form or new (including re-submission-invalid data)
#        #value assigned from partial..(1) single entry(_form.html.erb-line 44-47) (2) multiple entry(_form_by_paper.html.erb-line88-91)
#     end
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
  
  #11June2013---updated 23June20 13--revised 1-15Dec2015
  #Use ExamTemplate to apply weightage
  def apply_final_exam_into_grade
    subject_id = Exam.find(exam_id).subject_id
    examtype = Exam.find(exam_id).name
    fullmarks = Exammark.fullmarks(exam_id)
    grade_to_update = Grade.where('student_id=? and subject_id=?', student_id, subject_id).first
    diploma_subjects=[]
    Programme.roots.where(course_type: 'Diploma').each do |programme|
      programme.descendants.each do |descendant|
        diploma_subjects << descendant.id if descendant.course_type=='Subject'
      end
    end
    unless grade_to_update.nil? || grade_to_update.blank?
      if exampaper.name=="F" 
        grade_to_update.exam1marks=total_marks
        grade_to_update.summative=totalsummative if diploma_subjects.include?(subject_id) && exammark.total_mcq
      elsif exampaper.name=="R"
        grade_to_update.exam2marks=total_marks 
      elsif exampaper.name=="M"
        grade_to_update.scores.where(type_id: 6).first.marks=total_marks if @grade_to_update.scores.where(type_id: 6).count > 0
      end
      grade_to_update.save if grade_to_update.exam1marks && examtype == "F" 
      grade_to_update.save if grade_to_update.exam2marks && examtype == "R"
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
    #exam_template=exampaper.exam_template
    exam_template=Exam.where(id: examid).first.exam_template
    questions_count=0
    exam_template.question_count.each{|k,v|questions_count+=v['count'].to_i if k!="mcq" && (v['count']!='' || v['count']!=nil)}
    questions_count
  end
  
  def totalsummative
    @a=0
    exam_template=exampaper.exam_template
    exam_template.question_count.each do |k, v|
      if v['count']!='' || v['count']!=nil #&& v['weight']!=''                          
        qty=(v['count']).to_i
        if k=="mcq"
          @mcqcount=qty
          if v['weight']!=''
            @mcqweight_rate=  v['weight'].to_f/@mcqcount*1
          else
            @mcqweight_rate=0
          end
        elsif k=="meq"
          @meqcount=qty
          if v['weight']!=''
            @meqweight_rate=v['weight'].to_f/(@meqcount*20)
          else
            @meqweight_rate=0
          end
        elsif k=="seq" 
          @seqcount=qty
          if v['weight']!=''
            @seqweight_rate=  v['weight'].to_f/(@seqcount*10)
          else
            @seqweight_rate=0
          end
        elsif k=="acq"
          @acqcount=qty 
          if v['weight']!=''
            @acqweight_rate=  v['weight'].to_f/(@acqcount*1)
          else
            @acqweight_rate=0
          end
        elsif k=="osci"
          @oscicount=qty
          if v['weight']!=''
            @osciweight_rate=  v['weight'].to_f/(@oscicount*1)
          else
            @osciweight_rate=0
          end
        elsif k=="oscii"
          @osciicount=qty
          if v['weight']!=''
            @osciiweight_rate=  v['weight'].to_f/(@osciicount*1)
          else
            @osciiweight_rate=0
          end
        elsif k=="osce"
          @oscecount=qty
          if v['weight']!=''
            @osceweight_rate=  v['weight'].to_f/(@oscecount*1)
          else
            @osceweight_rate=0
          end
        elsif k=="ospe"
          @ospecount=qty
          if v['weight']!=''
            @ospeweight_rate=  v['weight'].to_f/(@ospecount*10)
          else
            @ospeweight_rate=0
          end
        elsif k=="viva"
          @vivacount=qty
          if v['weight']!=''
            @vivaweight_rate=  v['weight'].to_f/(@vivacount*1)
          else
            @vivaweight_rate=0
          end
        elsif k=="truefalse"
          @truefalsecount=qty
          if v['weight']!=''
             @truefalseweight_rate=  v['weight'].to_f/(@truefalsecount*1)
          else
             @truefalseweight_rate=0
          end
        end
      end
    end
    meq_count2=@meqcount;
    seq_count2=meq_count2+@seqcount;
    acq_count2=seq_count2+@acqcount;
    osci_count2=acq_count2+@oscicount;
    oscii_count2=osci_count2+@osciicount;
    osce_count2=oscii_count2+@oscecount;
    ospe_count2=osce_count2+@ospecount;
    viva_count2=ospe_count2+@vivacount;
    truefalse_count2=viva_count2+@truefalsecount;
    marks.each_with_index do |m, k|
      if (k < meq_count2)
        rate=@meqweight_rate
      elsif ((k >= meq_count2) && (k < seq_count2))
        rate=@seqweight_rate
      elsif ((k >= seq_count2) && (k < acq_count2))
        rate=@acqweight_rate
      elsif ((k >= acq_count2) && (k < osci_count2))
        rate=@osciweight_rate
      elsif ((k >= osci_count2) && (k < oscii_count2))
       rate=@osciiweight_rate
      elsif ((k >= oscii_count2) && (k < osce_count2))
        rate=@osceweight_rate
      elsif ((k >= osce_count2) && (k < ospe_count2))
        rate=@ospeweight_rate
      elsif ((k >= ospe_count2) && (k < viva_count2))
        rate=@vivaweight_rate
      elsif ((k >= viva_count2) && (k < truefalse_count2))
        rate=@truefalseweight_rate
      end
      if m.student_mark
        if rate==0
          @a+=m.student_mark
        else
          @a+=m.student_mark*rate
        end
      else
        @a=0
      end
    end
    if @mcqweight_rate==0
      fullmarks = exampaper.total_marks
      aaa=(total_mcq*1+@a)/fullmarks*100*0.70 
    else
      aaa=(total_mcq*@mcqweight_rate+@a)
    end
    aaa  
  end
end
