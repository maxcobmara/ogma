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
  
  def average_data(marks)
    marks.inject{|sum, element| sum + element}.to_f/marks.size 
  end
  
  def standard_deviation(marks)
    sum = marks.inject(0){|sum,element|sum+(element-average_data(marks))**2} 
    sample_variance = (1/marks.length.to_f * sum).to_f 
    Math.sqrt(sample_variance).to_f  #21June2013
  end
  
  def pass_rate(marks, mid)
    rate=0
    marks.each{|m|rate+=1 if m.to_f >= mid.to_f}
    rate
  end
  
  def percent_pass(marks, mid)
    students=Student.where(id: exampaper.exammarks.pluck(:student_id))
    pass_rate(marks, mid)/students.count.to_f*100
  end
  
  def marks_zero(marks)
    total=0
    marks.each{|m|total+=1 if m.to_f==0.0}
    total
  end
  
  def marks_20percent(marks, fullmarks)
    total=0
    twentypercent=fullmarks.to_f*20/100
    marks.each{|m|total+=1 if m.to_f < twentypercent}
    total
  end
  
  def marks_50percent(marks, fullmarks)
    total=0
    twentypercent=fullmarks.to_f*20/100
    fifthtypercent=fullmarks.to_f*50/100
    marks.each{|m|total+=1 if m.to_f < fifthtypercent && m.to_f >=twentypercent}
    total
  end
  
  def marks_less80percent(marks, fullmarks)
    total=0
    fifthtypercent=fullmarks.to_f*50/100
    eightypercent=fullmarks.to_f*80/100
    marks.each{|m|total+=1 if m.to_f < eightypercent && m.to_f >=fifthtypercent}
    total
  end
  
  def marks_80abovepercent(marks, fullmarks)
    total=0
    eightypercent=fullmarks.to_f*80/100
    marks.each{|m|total+=1 if m.to_f >= eightypercent}
    total
  end
  
  def a_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m==4.00}
    total
  end
  
  def a_minus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 4.00 && m >= 3.67}
    total
  end
  
  def b_plus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 3.67 && m >= 3.33}
    total
  end
  
  def b_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 3.33 && m >= 3.00}
    total
  end
  
  def b_minus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 3.00 && m >= 2.67}
    total
  end
  
  def c_plus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 2.67 && m >= 2.33}
    total
  end
  
  def c_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 2.33 && m >= 1.67}
    total
  end
  
  def c_minus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 1.67 && m >= 1.33}
    total
  end
  
  def d_plus_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 1.33 && m >= 1.00}
    total
  end
  
  def d_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m < 1.00 && m > 0.00}
    total
  end
  
  def e_count(ngs)
    total=0
    ngs.each{|m|total+=1 if m==0.0}
    total
  end
  
  #Export Excel - _student_and_marks.html.haml
  def self.to_csv3(options = {})
    # TODO - refractor this
    exam_paper=all.first.exampaper
    exammarks=exam_paper.exammarks
    students=Student.where(id: exammarks.pluck(:student_id))
    subjectid=exam_paper.subject_id

    #Absent data
    absent_grades=Grade.where(subject_id: subjectid).where.not(student_id: students)
    absent_exammark_exist=[]
    exammarks.each do |exammark|
      absent_exammark_exist << exammark if exammark.total_marks==0 || exammark.totalsummative==0
    end  

    #Formative Full marks = total formative weightage, Summative Marks
    onegrade=Grade.where(student_id: students[0].id).where(subject_id: subjectid).first
    formative_weightage=onegrade.scores.sum(:weightage)
    mid_formative=formative_weightage/2.0
    summative_weightage=onegrade.examweight
    mid_summative=summative_weightage/2.0
    
    #Final Full marks (exam.total_marks != exammark.total_marks)
    finalmarks_full=exam_paper.total_marks
    mid_finalmarks=finalmarks_full/2.0
    mid_finalscores=100/2.0
    qcount=[]
    qrate=[]
    qfullmarks=[]
    qmarks_ea=[]
    qtype=[]

    exam_paper.exam_template.question_count.each do |k,v|
      qtype << k if v["count"]!=''
      if v["weight"]!='' && v["count"]!=''
        if v["full_marks"] && v["full_marks"]!='' 
          qmarks_ea << v["full_marks"].to_f / v["count"].to_i
          qfullmarks << v["full_marks"].to_f
          qcount << v["count"].to_i
        else
          #when full marks not exist, use STANDARD MARKS as below : pls note - applicable to MCQ, MEQ & SEQ only
          if k=="mcq"
            qmarks_ea << 1 
            qfullmarks << v["count"].to_i*1 
            qcount << v["count"].to_i
          elsif k=="seq" 
            qmarks_ea << 10
            qfullmarks << (v["count"].to_i*10)
            qcount << v["count"].to_i
          elsif k=="meq"
            qmarks_ea << 20
            qfullmarks << (v["count"].to_i*20)
            qcount << v["count"].to_i
          else
            #assume 1 for marks for ea question
            qmarks_ea << 1
            qfullmarks <<  v["count"].to_i
            qcount << v["count"].to_i
          end
        end
      elsif  v["weight"]=='' && v["count"]!=''
        #when weightage not exist, but count exist
        qrate << 0
        if k=="mcq"
          qmarks_ea << 1 
          qfullmarks << v["count"].to_i*1 
          qcount << v["count"].to_i
        elsif k=="seq"
          qmarks_ea << 10
          qfullmarks << v["count"].to_i*10
          qcount << v["count"].to_i
        elsif k=="meq"
          qmarks_ea << 20
          qfullmarks << v["count"].to_i*20
          qcount << v["count"].to_i
        else
          #assume 1 for marks for ea question
          qmarks_ea << 1
          qfullmarks << v["count"].to_i*1 
          qcount << v["count"].to_i
        end
      else
        qmarks_ea << 1 if v["count"]!=''
        qcount << v["count"].to_i if v["count"]!=''
      end
    end
    @mcq_count= qcount[0]
    @meq_count= qcount[1]
    @seq_count=qcount[2]  
    @acq_count=qcount[3]
    @osci_count=qcount[4]
    @oscii_count=qcount[5]
    @osce_count=qcount[6]
    @ospe_count=qcount[7]
    @viva_count=qcount[8]
    @truefalse_count=qcount[9]

    total_questions = qcount.sum
    total_mcq_questions=0
    exam_paper.exam_template.question_count.each{|k,v|total_mcq_questions=v['count'].to_i if k=="mcq"}
    total_nonmcq_questions=total_questions - total_mcq_questions
    questionstype=qtype
    questionstype_count = qtype.count

    ######
    #----------------
    non_mcq_titlecolumns=[]
    non_mcq_2titlecolumns=[]
    1.upto(qtype.count-1).each do |x|
      non_mcq_titlecolumns << qtype[x].upcase
      1.upto(qcount[x]).each do |y|
        non_mcq_titlecolumns << qtype[x].upcase if y < qcount[x]
        non_mcq_2titlecolumns << "Q #{y} (#{qmarks_ea[x]})"
      end
    end
    title_row=[ 'No', I18n.t('student.students.name'), I18n.t('student.students.matrixno'), I18n.t('student.students.icno'), 
	         'CA+MSE / '+I18n.t( 'exam.examanalysis.formative'),'MCQ' ]+non_mcq_titlecolumns+[I18n.t('exam.examanalysis.final_exam'), I18n.t('exam.examanalysis.final_score'), I18n.t('exam.examanalysis.grade'), 'NG' ]
    title_row2=["\'\'","\'\'","\'\'","\'\'",formative_weightage.to_s+"%",qfullmarks[0]]+non_mcq_2titlecolumns+[summative_weightage.to_s+"%", (formative_weightage+summative_weightage).to_s+"%", "\'\'","\'\'"]
    bil=0
    marks_by_students=[]
    formatives=[]
    mcqs=[]
    finalmarks=[]
    finalscores=[]
    grading=[]
    ngs=[]
    for student in students.sort_by{|x|[x.id, x.name]}   
      total_formative=Grade.where(student_id: student.id).where(subject_id: subjectid).first.formative
      formatives << total_formative.to_f
      total_mcq=exammarks.where(student_id: student.id).first.total_mcq
      mcqs << total_mcq.to_f
      marks_line_per_student=exammarks.where(student_id: student.id).first.marks.order(created_at: :asc)
      marks_by_students << marks_line_per_student.pluck(:student_mark)
      finalmarks << Grade.where(student_id: student.id).where(subject_id: subjectid).first.summative.to_f
      finalscores << Grade.where(student_id: student.id).where(subject_id: subjectid).first.finalscore.to_f
      grading << Grade.where(student_id: student.id).where(subject_id: subjectid).first.render_grading[-2,2]
      ngs << Grade.where(student_id: student.id).where(subject_id: subjectid).first.set_NG.to_f
    end
    #rearrange, group student marks by questions
    marks_by_questions=[]
    0.upto(total_nonmcq_questions-1).each do |count|
      arr=[]
      marks_by_students.each do |studentmark|
        arr << studentmark[count].to_f
      end
      marks_by_questions << arr
    end
    #Absent Student (Final Exam) - Grade MUST EXIST & Exammark no need to exist, even if exist (due to Create Multiple), MUST be exammark.totalsummative==0 || exammark.total_marks==0, to be considered as ABSENT
    absent_formatives=[]
    present_formatives=[]
    absent_exammarks=[]
    absent_final_scores=[]
    absent_gradings=[]
    absent_ngs=[]
    absent_lines=[]
    if absent_exammark_exist.count > 0 || absent_grades.count > 0
      for grade in absent_grades
        absent_formative=grade.scores.sum(:marks)
        if absent_exammark_exist.map(&:student_id).include?(grade.student_id)
          #exammarks & grade exist
          mcqmarks=0.00
          othermarks=0.00
          finalpapermarks=0.00
        else
          #only grade exist
          mcqmarks="-"
          othermarks="-"
          finalpapermarks="-"
        end
        aa=[]
        0.upto(total_nonmcq_questions-1).each do |x|
           aa << othermarks
        end
        absent_final_score=grade.finalscore
        absent_grading=grade.render_grading[-2,2]
        absent_ng=grade.set_NG
        if absent_formative.to_f > 0
          present_formatives << absent_formative 
        else
          absent_formatives << absent_formative  
        end
        absent_exammarks << 0
        absent_final_scores << absent_final_score
        absent_gradings << absent_grading
        absent_ngs << absent_ng
        absent_line=[ grade.studentgrade.name, grade.studentgrade.matrixno.nil? ? "\'\'" : student.matrixno, grade.studentgrade.icno, absent_formative, mcqmarks]+aa+[finalpapermarks, absent_final_score, absent_grading, absent_ng]     
      end
      absent_lines << absent_line
    end
    
    #COUNT
    total_candidates=formatives.count+absent_formatives.count+present_formatives.count
    #Below : use standard absent_exammarks for ALL final paper related columns
    total_mcqs=mcqs.count+absent_exammarks.count
    non_mcq_count=[]
    0.upto(total_nonmcq_questions-1).each do |x|
      non_mcq_count << marks_by_questions[x].count+absent_exammarks.count
    end
    finalexam_count=finalmarks.count+absent_exammarks.count
    finalscore_count=finalscores.count+absent_final_scores.count
    ngs_count=ngs.count+absent_ngs.count
    #Above : & for both conditions : 1)Grade with Exammark exist 2) Grade w/o Exammark existance
    count_line =["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.count'), total_candidates, total_mcqs]+non_mcq_count+[finalexam_count, finalscore_count, "\'\'", ngs_count]
    
    #ATTEND
    total_attendees=formatives.count+present_formatives.count
    #exammarks section should not consist any absent data
    non_mcq_count_attend=[]
    0.upto(total_nonmcq_questions-1).each do |x|
       non_mcq_count_attend << marks_by_questions[x].count
    end
    #exammarks section ended here
    if present_formatives.count > 0
      all_final_scores=finalscores.count+absent_final_scores.count
      all_ngs=ngs.count+absent_ngs.count
    else
      all_final_scores=finalscores.count
      all_ngs=ngs.count
    end
    attend_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.attend'), total_attendees, mcqs.count]+non_mcq_count_attend+[finalmarks.count, all_final_scores, "\'\'", all_ngs]
    
    #ABSENT
    #exammarks related
    non_mcq_count_absent=[]
    0.upto(total_nonmcq_questions-1).each do |x|
        non_mcq_count_absent << total_candidates-marks_by_questions[x].count
    end
    #exammarks
    absent_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.absent'), total_candidates-total_attendees, total_candidates-mcqs.count]+non_mcq_count_absent+ [total_candidates-finalmarks.count, total_candidates-total_attendees, "\'\'", total_candidates-total_attendees]
    
     #MIN 
     non_mcq_min=[]
     0.upto(total_nonmcq_questions-1).each do |x|
         non_mcq_min << marks_by_questions[x].min
     end 
     min_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.min'), formatives.min, mcqs.min]+non_mcq_min+[finalmarks.min, finalscores.min, "\'\'", ngs.min]
    
     #MAX
     non_mcq_max=[]
     0.upto(total_nonmcq_questions-1).each do |x|
         non_mcq_max << marks_by_questions[x].max
     end
     max_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.max'), formatives.max, mcqs.max]+non_mcq_max+[finalmarks.max, finalscores.max, "\'\'", ngs.max]
     
     #MEAN (AVERAGE)
     analysis=all.first
     non_mcq_average=[]
     0.upto(total_nonmcq_questions-1).each do |x|
          non_mcq_average << analysis.average_data(marks_by_questions[x])
     end
     average_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.average'), analysis.average_data(formatives), analysis.average_data(mcqs)]+non_mcq_average+ [analysis.average_data(finalmarks), analysis.average_data(finalscores), "\'\'", analysis.average_data(ngs)]

     #SD-Population / SD- Deviation
     non_mcq_sd_deviation=[]
     0.upto(total_nonmcq_questions-1).each do |x|
         non_mcq_sd_deviation << sprintf('%.2f', analysis.standard_deviation(marks_by_questions[x]))
     end 
     sd_deviation_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.sd_deviation'), sprintf('%.2f', analysis.standard_deviation(formatives)), sprintf('%.2f',analysis.standard_deviation(mcqs))]+ non_mcq_sd_deviation+[sprintf('%.2f', analysis.standard_deviation(finalmarks)), sprintf('%.2f',analysis.standard_deviation(finalscores)), "\'\'", sprintf('%.2f',analysis.standard_deviation(ngs))]

     #Pass % -  Jumlah kelulusan (dr jumlah pelajar)
     item=0
     non_mcq_passing_rate=[]
     1.upto(qtype.count-1).each do |x|
       1.upto(qcount[x]).each do |y|
         non_mcq_passing_rate << analysis.pass_rate(marks_by_questions[item], qmarks_ea[x]/2.0)
         item+=1
       end
     end 
     passing_rate_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.pass_rate'), analysis.pass_rate(formatives, mid_formative), analysis.pass_rate(mcqs, qfullmarks[0]/2.0)]+ non_mcq_passing_rate+[analysis.pass_rate(finalmarks, mid_finalmarks), analysis.pass_rate(finalscores, mid_finalscores), "\'\'", analysis.pass_rate(ngs, 2.00)]

     #% Pass -  Peratus kelulusan (dr jumlah pelajar)  
     item=0
     non_mcq_percent_passed=[]
     1.upto(qtype.count-1).each do |x|
       1.upto(qcount[x]).each do |y|
         pass_rate=analysis.pass_rate(marks_by_questions[item], qmarks_ea[x]/2.0)
         total_student=students.count
         non_mcq_percent_passed << pass_rate/total_student.to_f*100.0
         item+=1
       end
     end
     percent_passed_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.percent_pass'), analysis.percent_pass(formatives, mid_formative), analysis.percent_pass(mcqs, qfullmarks[0]/2.0)]+non_mcq_percent_passed+[analysis.percent_pass(finalmarks, mid_finalmarks), analysis.percent_pass(finalscores, mid_finalscores), "\'\'", analysis.percent_pass(ngs, 2.00)]

    #Marks=0 count per question
    item=0
    non_mcq_marks_zero=[]
    1.upto(qtype.count-1).each do |x|
      1.upto(qcount[x]).each do |y|
        non_mcq_marks_zero << analysis.marks_zero(marks_by_questions[item])
        item+=1
      end
    end
    marks_zero_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.marks')+' 0', analysis.marks_zero(formatives), analysis.marks_zero(mcqs)]+non_mcq_marks_zero+ ['GRED', 'A (>80)', '4.00', analysis.a_count(ngs)]
         
    #Marks < 20% per question
    item=0
    non_mcq_marks_less20=[]
    1.upto(qtype.count-1).each do |x|
      1.upto(qcount[x]).each do |y|
        non_mcq_marks_less20 << analysis.marks_20percent(marks_by_questions[item], qmarks_ea[x])
        item+=1
      end
    end
    #/%td GRED
    marks_less20_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.marks')+' < 20%', analysis.marks_20percent(formatives, formative_weightage), analysis.marks_20percent(mcqs, qcount[0])]+non_mcq_marks_less20+["\'\'", 'A- (75-79)', '3.67', analysis.a_minus_count(ngs)]

    #Marks < 50% per question
    non_mcq_marks_less50=[]
    item=0
    1.upto(qtype.count-1).each do |x|
      1.upto(qcount[x]).each do |y|
        non_mcq_marks_less50 << analysis.marks_50percent(marks_by_questions[item], qmarks_ea[x])
        item+=1
      end
    end
    #/%td GRED
    marks_less50_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.marks')+' < 50%', analysis.marks_50percent(formatives, formative_weightage), analysis.marks_50percent(mcqs, qcount[0])]+non_mcq_marks_less50+["\'\'", 'B+ (70-74)', '3.33',analysis.b_plus_count(ngs) ]

    #Marks <=80% per question
    non_mcq_marks_less80=[]
    item=0
    1.upto(qtype.count-1).each do |x|
      1.upto(qcount[x]).each do |y|
        non_mcq_marks_less80 << analysis.marks_less80percent(marks_by_questions[item], qmarks_ea[x])
        item+=1
      end
    end
    #/%td GRED
    marks_less80_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.marks')+' <=80%', analysis.marks_less80percent(formatives, formative_weightage), analysis.marks_less80percent(mcqs, qcount[0])]+non_mcq_marks_less80+["\'\'", 'B (65-69)', '3.00', analysis.b_count(ngs)]
     
    #/Marks > 80% per question
    item=0
    non_mcq_marks_more80=[]
    1.upto(qtype.count-1).each do |x|
      1.upto(qcount[x]).each do |y|
        non_mcq_marks_more80 << analysis.marks_80abovepercent(marks_by_questions[item], qmarks_ea[x])
        item+=1
      end
    end
    #/%td GRED
    marks_more80_line=["\'\'","\'\'","\'\'", I18n.t('exam.examanalysis.marks')+' >80%', analysis.marks_80abovepercent(formatives, formative_weightage), analysis.marks_80abovepercent(mcqs, qcount[0])]+non_mcq_marks_more80+["\'\'", 'B- (60-64)', '2.67', analysis.b_minus_count(ngs)]
    
    #GRADING ONLY
    bb=[]
    0.upto(total_nonmcq_questions-1).each do |x|
      bb << "\'\'"
    end
    cplus_line=["\'\'","\'\'","\'\'","\'\'","\'\'","\'\'","\'\'",]+bb+['C+ (55-59)', '2.33', analysis.c_plus_count(ngs)]
    c_line=["\'\'","\'\'","\'\'","\'\'","\'\'","\'\'","\'\'",]+bb+['C (50-54)', '2.00', analysis.c_count(ngs)]
    cminus_line=["\'\'","\'\'","\'\'","\'\'","\'\'","\'\'","\'\'",]+bb+['C- (45-49)', '1.67', analysis.c_minus_count(ngs)]
    dplus_line=["\'\'","\'\'","\'\'","\'\'","\'\'","\'\'","\'\'",]+bb+['D+ (40-44)', '1.33', analysis.d_plus_count(ngs)]
    d_line=["\'\'","\'\'","\'\'","\'\'","\'\'","\'\'","\'\'",]+bb+['D (35-39)', '1.00', analysis.d_count(ngs)]
    e_line=["\'\'","\'\'","\'\'","\'\'","\'\'","\'\'","\'\'",]+bb+['E (<35)', '0.00', analysis.e_count(ngs)]
  
    #----------------
    bil2=0
    CSV.generate(options) do |csv|
      csv << ["\'\'", exam_paper.exam_name_subject_date ] #title added
      csv << [] #blank row added
      csv << title_row
      csv << title_row2
      for student in students.sort_by{|x|[x.id, x.name]}    
        csv << ["#{bil2+=1}", student.name, student.matrixno.nil? ? "\'\'" : student.matrixno, student.icno, formatives[bil2-1], mcqs[bil2-1]]+marks_by_students[bil2-1]+[finalmarks[bil2-1], finalscores[bil2-1], grading[bil2-1], ngs[bil2-1]]
      end
      absent_lines.each do |abl|
        csv << ["#{bil2+=1}"]+abl 
      end
      csv << [] #blank row added
      csv << [] #blank row added
      csv << count_line
      csv << attend_line
      csv << absent_line
      csv << min_line
      csv << max_line
      csv << [] #blank row added
      csv << average_line
      csv << sd_deviation_line
      csv << [] #blank row added
      csv << passing_rate_line
      csv << percent_passed_line
      csv << [] #blank row added
      csv << marks_zero_line
      csv << marks_less20_line
      csv << marks_less50_line
      csv << marks_less80_line
      csv << marks_more80_line
      csv << cplus_line
      csv << c_line
      csv << cminus_line
      csv << dplus_line
      csv << d_line
      csv << e_line
    end
  end
  
  
end