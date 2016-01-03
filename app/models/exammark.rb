class Exammark < ActiveRecord::Base
  belongs_to :exampaper, :class_name =>'Exam', :foreign_key => 'exam_id'
  belongs_to :studentmark, :class_name => 'Student', :foreign_key => 'student_id'
  has_many :marks, :dependent => :destroy                                                     
  accepts_nested_attributes_for :marks#, :reject_if => lambda { |a| a[:mark].blank? }   #use of validates_presence_of in mark model
  
  before_save :set_total_mcq
  after_save :apply_final_exam_into_grade 
  validates_presence_of   :student_id, :exam_id
  validates_uniqueness_of :student_id, :scope => :exam_id, :message => " - Mark of this exam for selected student already exist. Please edit/delete existing mark accordingly."
  validate :marks_must_not_exceed_maximum, :total_mcq_must_an_integer
  
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
  
  #########should refers to Saved Entered marks
  def total_marks
    marks.sum(:student_mark)+total_mcq.to_i
  end
  #########
  
  # NOTE - total_marks refers to SAVED marks not current value
  # refer - marks_must_not_exceed_maximum - 4 sample of current value
  def total_marks2
    diploma=Programme.where(course_type: 'Diploma')
    radiografi=diploma.where('name ILIKE?', '%Radiografi%').first.id
    carakerja=diploma.where('name ILIKE?', '%Jurupulih Perubatan Cara Kerja%').first.id
    ###
     #if !(@exammarks[0].exampaper.subject.root_id==radiografi || @exammarks[0].exampaper.subject.root_id==carakerja) && @exammarks[0].exampaper.name=='F'
    ###
    if exampaper.subject.root_id==radiografi || exampaper.subject.root_id==carakerja
      total=marks.sum(:student_mark)+total_mcq.to_i       #actual total entered by user
    else
      if exampaper.name=='F' || exampaper.name=='R'
        #For Final / Repeat - other than Radiografi & Cara Kerja
        #mcqweight=exampaper.exam_template.question_count['mcq']['weight']
        #if mcqweight && mcqweight!=''
        #  total=totalsummative
        #else
          total=marks.sum(:student_mark)+total_mcq.to_i  
        #end
      else
        #For Mid Sem Papers - other than Radiografi & Cara Kerja 
        mcqweight=exampaper.exam_template.question_count['mcq']['weight']
        if mcqweight && mcqweight!=''
          #weightage exist
          total=totalsummative
        else
          #weightage not exist - collect entered values
          total=total_mcq
          marks.each{|x|total+=x.student_mark}
        end
        #total=totalsummative    #refer _form_multiple: total marks view shall display total marks entered if weightage not exist, otherwise display total in weightage 
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
  # TODO - to confirm ALL posbasic programme - Intake March & September?
  def self.set_intake_group(examyear,exammonth,semester,cuser)    #semester refers to semester of selected subject - subject taken by student of semester???
    posbasiks=['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']
    @unit_dept = cuser.userable.positions.first.unit 
    #Unit = Pengkhususan/Diploma Lanjutan/Pos Basik , Main Tasks = Ketua Program Pengkhususan/Pos Basik Perawatan Koronari/Diploma Lanjutan Kebidanan

     #if exammonth.to_i <= 7
     if (@unit_dept && posbasiks.include?(@unit_dept)==true && exammonth.to_i <= 9) || (@unit_dept && posbasiks.include?(@unit_dept)==false && exammonth.to_i <= 7)                                                  # for 1st semester-month: Jan-July, exam should be between Feb-July
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
          elsif (semester.to_i+1)/2 > 1                                                           #>=1***
            @intake_year = @current_year.to_i-((semester.to_i+1)%2)
	  #3Jan 2015 - sample : Kejururawatan - Semester 2 - intake 1 July 2014, exam on 28 April 2015, intake year should be previous year***
	  elsif (semester.to_i+1)/2 ==1
            @intake_year = @current_year.to_i-1
          end  
          #29June2013-------------------
          @intake_sem = @current_sem + 1 
        end 
     elsif (@unit_dept && posbasiks.include?(@unit_dept)==true && exammonth.to_i > 9) || (@unit_dept && posbasiks.include?(@unit_dept)==false && exammonth.to_i > 7)                                                  # 2nd semester starts on July-Dec- exam should be between August-Dec
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
            elsif (semester.to_i+1)/2 > 1                                               #>=***
              @intake_year = @current_year.to_i-((semester.to_i+1)%2)
            #3Jan 2015 - sample : Kejururawatan - Semester 2 - intake 1 Jan 2015, exam on 28 Dec 2015, intake year should be current year***
	    elsif (semester.to_i+1)/2 ==1
	      @intake_year = @current_year.to_i
            end  
            #29June2013-------------------
          @intake_sem = @current_sem - 1
        end 
     end
     #return @intake_sem.to_s+'/'+@intake_year.to_s   #giving this format -->  2/2012  --> previously done on examresult(2012)

     if @intake_sem == 1 
       @intake_month = '03' if @unit_dept && posbasiks.include?(@unit_dept)==true #@unit_dept == "Kebidanan"
       @intake_month = '01' if @unit_dept && posbasiks.include?(@unit_dept)== false #@unit_dept != "Kebidanan"
     elsif @intake_sem == 2
       @intake_month = '09' if @unit_dept && posbasiks.include?(@unit_dept)==true #@unit_dept == "Kebidanan"
       @intake_month = '07' if @unit_dept && posbasiks.include?(@unit_dept)==false #@unit_dept != "Kebidanan"
     end

     return @intake_year.to_s+'-'+@intake_month+'-01'  #giving this format -->  2/2012
  end
  #14March2013
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    posbasiks=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
    if search 
      if search == '0'
        @exammarks = Exammark.all.order(:exam_id)
      elsif search == '1'
         exampapers = Exam.where("subject_id IN (?)", common_subject).pluck(:id)
        @exammarks = Exammark.where("exam_id IN (?)", exampapers).order(:exam_id)
      elsif search=='2'
        programme_ids=Programme.where(course_type: posbasiks).pluck(:id)
        subject_ids=[]
        programme_ids.each do |progid|
          Programme.where(id: progid).first.descendants.each do |descendant|
            subject_ids << descendant.id if descendant.course_type=='Subject'
          end
        end
        exampapers = Exam.where("subject_id IN (?)", subject_ids).pluck(:id)
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
    Exam.find(exam_id).exam_template.template_full_marks
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
        #grade_to_update.summative=totalsummative if diploma_subjects.include?(subject_id) && total_mcq
        grade_to_update.summative=totalsummative if total_mcq
      elsif exampaper.name=="R"
        grade_to_update.exam2marks=total_marks 
      elsif exampaper.name=="M"
        grade_to_update.scores.where(type_id: 6).first.marks=total_marks if grade_to_update.scores.where(type_id: 6).count > 0
      end
      grade_to_update.save if grade_to_update.exam1marks && examtype == "F" 
      grade_to_update.save if grade_to_update.exam2marks && examtype == "R"
    end
  end
  #11June2013------updated 23June2013
  
  def self.get_valid_exams
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
  
  #use this if total_in_weight in exam_template ==0 (weightage not exist in exam template)
  def total_weightage
    if Programme.where(id: exampaper.subject.root_id).first.course_type=='Diploma'
      total_weight=70 if exampaper.name=='F' || exampaper.name=='R'
      total_weight=30 if exampaper.name=='M' #other formula : 15% exam, 10% continuous assessment, 5% affective
    else
      total_weight=60 if exampaper.name=='F' || exampaper.name=='R'
      total_weight=40 if exampaper.name=='M'
    end
    total_weight
  end
  
  def totalsummative
    @a=0
    exam_template=exampaper.exam_template
    qrate=[]
    qcount=[]
    exam_template.question_count.each do |k,v|
      qcount << v["count"].to_i
      #if v["weight"]!='' && v["count"]!=''
      if !v["weight"].blank? && !v["count"].blank?
        #previous structure (has no full_marks) - MUST check if v["full_marks"] of previously SAVED templates EXIST first 
        #division by 0.0 shall gives infinity, as error : Index pg (Infinity --> app/models/exammark.rb:383:in `to_r')
        #if v["full_marks"] && v["full_marks"]!='' 
        if v["full_marks"] && !v["full_marks"].blank?
          qrate << v["weight"].to_f / v["full_marks"].to_f
        else
          #when full marks not exist, use STANDARD MARKS as below : pls note - applicable to MCQ, MEQ & SEQ only
          if k=="mcq"
            qrate << v["weight"].to_f / v["count"].to_i*1 
          elsif k=="seq" || k=="ospe"
            qrate << v["weight"].to_f / (v["count"].to_i*10)
          elsif k=="meq"
            qrate << v["weight"].to_f / (v["count"].to_i*20)
          else
            #assume 1 for marks for ea question
            qrate << v["weight"].to_f / v["count"].to_i
          end
        end
      else
        qrate << 0
      end
    end
    @mcqcount= qcount[0]
    @mcqweight_rate= qrate[0]
    @meqcount= qcount[1]
    @meqweight_rate=qrate[1]
    @seqcount=qcount[2]
    @seqweight_rate=qrate[2]
  
    @acqcount=qcount[3]
    @acqweight_rate=qrate[3]
    @oscicount=qcount[4]
    @osciweight_rate=qrate[4]
    @osciicount=qcount[5]
    @osciiweight_rate=qrate[5]
    @oscecount=qcount[6]
    @osceweight_rate=qrate[6]
    @ospecount=qcount[7]
    @ospeweight_rate=qrate[7]
    @vivacount=qcount[8]
    @vivaweight_rate=qrate[8]
    @truefalsecount=qcount[9]
    @truefalseweight_rate=qrate[9]
    
    meq_count2=@meqcount;
    seq_count2=meq_count2+@seqcount;
    acq_count2=seq_count2+@acqcount;
    osci_count2=acq_count2+@oscicount;
    oscii_count2=osci_count2+@osciicount;
    osce_count2=oscii_count2+@oscecount;
    ospe_count2=osce_count2+@ospecount;
    viva_count2=ospe_count2+@vivacount;
    truefalse_count2=viva_count2+@truefalsecount;
    marks.sort_by{|x|x.created_at}.each_with_index do |m, k|
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
    if @mcqweight_rate==0 || @mcqweight_rate==0.0
      fullmarks = exampaper.total_marks
      if exam_template.total_in_weight > 0
        aaa=(total_mcq*1+@a)/(fullmarks*exam_template.total_in_weight.to_f)  #weight in decimal (0.70)
      else
        aaa=(total_mcq*1+@a)/fullmarks*total_weightage.to_f   #weight already in  % (30, 70, 40, 60)
      end
    else
      aaa=(total_mcq*@mcqweight_rate)+@a
    end
    aaa  
  end
  
  def marks_must_not_exceed_maximum
    unless id.nil? || id.blank?
      
      #########
      paper=Exam.find(exam_id)
      fullmarks=paper.set_full_marks
      exceed_total=[]
      mcq_max=0
      current_marks=0
      marks.each{|m|current_marks+=m.student_mark}
      current_total_marks=total_mcq+current_marks
      if paper.name!="M"
        # NOTE Final - total marks is entered values[displayed only for Radiografi & Cara Kerja], + display of summative (in % weightage) [for all programmes]
        paper.exam_template.question_count.each{|k,v|mcq_max=(v['count'].to_i) if k=="mcq"}
        other_max=fullmarks-mcq_max
        exceed_total << current_total_marks.to_f if current_total_marks > fullmarks || total_mcq > mcq_max || (marks && current_marks > other_max) 
      else
        # NOTE Mid sem - based on entered values --> total marks is generated values (in % weightage)
        paper.exam_template.question_count.each{|k,v|mcq_max=v['count'].to_f if k=="mcq"}
        other_max=fullmarks-mcq_max
        exceed_total << total_mcq.to_f if total_mcq > mcq_max || (marks && current_marks > other_max)
      end
      ##########
      if exceed_total.count > 0
        errors.add(:mark, I18n.t('exam.exammark.exceed_total')) 
      end
    
    end
  end
  
  def total_mcq_must_an_integer
    if total_mcq && total_mcq/total_mcq.to_i > 1.0
      errors.add(:base, I18n.t('exam.exammark.mcq_must_an_integer'))
    end
  end
  
end
