class Examresult < ActiveRecord::Base
  validates_presence_of :semester, :programme_id, :examdts, :examdte
  #ref:http://stackoverflow.com/questions/923796/how-do-you-validate-uniqueness-of-a-pair-of-ids-in-ruby-on-rails
  validates_uniqueness_of :semester, :scope => [:programme_id, :examdts], :message => I18n.t('exam.examresult.record_must_unique')
  belongs_to :programmestudent, :class_name => 'Programme', :foreign_key => 'programme_id' 
  has_many :resultlines, :dependent => :destroy                                                     
  accepts_nested_attributes_for :resultlines, :reject_if => lambda { |a| a[:student_id].blank? }
    
  after_save :update_student_status_when_repeated
  
  #22Feb2016-Steps when Repeat Sem in Examresult - 
  #1) Update Student (sstatus & status_remark fields) 
  #2) During next semester, Create Exammarks & Grade as usual (select intake, -> student for prev intake[of selected intake] with status 'Repeat' will be takes into acct)
  # note - validation required in Grades, duplicates for a student/subject set only allowed when student status is 'Repeat' ie. 'Ulang semester'
  def update_student_status_when_repeated
    for rline in resultlines
      if rline.remark=="5"
        all_resultlines=Resultline.where(student_id: rline.student_id).pluck(:examresult_id)
        examresults_sem=Examresult.where(id: all_resultlines).pluck(:semester)
        latest_sem=examresults_sem.max
        if latest_sem==semester
          student_toupdate=Student.where(id: rline.student_id).first
          student_toupdate.sstatus="Repeat"
          prev_remark=student_toupdate.sstatus_remark
          if prev_remark=='' || prev_remark.nil?
            status_remark=semester.to_s
          else
            status_remark=prev_remark+","+semester.to_s if prev_remark.include?(semester.to_s)==false
          end
          if status_remark
            student_toupdate.sstatus_remark=status_remark
            student_toupdate.save
          end
        end
      end
    end
  end
  
  def self.search2(search)
    if search 
      if search == '0'  #admin
        @examresults = Examresult.all.order(examdts: :desc)
      elsif search == '1' #common subject lecturer
        @result_with_common_subjects=[]
        Examresult.all.each do |result|
        subject_ids=Examresult.get_subjects(result.programme_id, result.semester).map(&:id)
          common_subject_ids=Programme.where(course_type: 'Commonsubject').pluck(:id)
          common_exist=common_subject_ids & subject_ids
          if common_exist.count > 0
           @result_with_common_subjects << result.id
          end
        end
        @examresults = Examresult.where(id: @result_with_common_subjects)
      elsif search=='2' #posbasic SUP
        posbasiks=["Diploma Lanjutan", "Pos Basik", "Pengkhususan"]
        postbasic_prog_ids=Programme.roots.where(course_type: posbasiks).pluck(:id)
        @examresults = Examresult.where(programme_id: postbasic_prog_ids)
      else
        @examresults = Examresult.where(programme_id: search)
      end
    end
  end
  
  def render_semester
    (DropDown::SEMESTER.find_all{|disp, value| value == semester}).map {|disp, value| disp}[0]
  end
  
  # define scope
  def self.keyword_search(query)
    programme_ids = Programme.where('name ILIKE(?)', "%#{query}%").where(course_type: ['Diploma', 'Diploma Lanjutan', 'Pos Basik', 'Pengkhususan']).pluck(:id)
    where(programme_id: programme_ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search]
  end
  
  def retrieve_subject
    parent_sem=Programme.where(id: programme_id).first.descendants.at_depth(1)
    parent_sem.each{ |sem| @subject_ids = sem.children.map(&:id) if sem.code == semester.to_s }
    Programme.where(id: @subject_ids)
  end
  
  def intake_group
    examyear=examdts.year 
    exammonth=examdts.month
    #kebidanan=Programme.where(name: 'Kebidanan').first.id
    posbasiks_ids=Programme.where(course_type: ['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']).pluck(:id)
    if exammonth < 7 #kebidanan sept-prev year [jan-feb](sem 1) or others [mei-jun](sem 1) 
      if (semester.to_i-1) % 2 == 0                                         # sem 1, thn 1 (semester=1), sem 3, sem 5 - semester GANJIL
        if posbasiks_ids.include?(programme_id) #programme_id==kebidanan
          intake_month = '09'
          intake_year = examyear-1
        else
          intake_year = examyear.to_i-((semester.to_i-1)/2)
          intake_month = '01'
        end
      elsif (semester.to_i-1) % 2 != 0
        if (semester.to_i+1)/2.0 > 3  
          intake_year = examyear.to_i-((semester.to_i+1)%2)-2
        elsif (semester.to_i+1)/2.0 > 2
          intake_year = examyear.to_i-((semester.to_i+1)%2)-1
        elsif (semester.to_i+1)/2.0 > 1
          intake_year = examyear.to_i-((semester.to_i+1)%2)  
        end
        if posbasiks_ids.include?(programme_id) #programme_id==kebidanan
          intake_month='03'
        else
          intake_month='07'
        end
      end
    elsif exammonth < 9 && exammonth > 6 #kebidanan only
      if semester.to_i==1
        intake_year = examyear
        intake_month = '03'
      elsif semester.to_i==2
        intake_year = examyear-1
        intake_month = '09'
      end
    elsif exammonth > 9 #others only 
      if (semester.to_i-1) % 2 == 0  
        intake_year = examyear.to_i-((semester.to_i-1)/2) 
        intake_month = '07'
      elsif (semester.to_i-1) % 2 != 0
        intake_month = '01'
        if (semester.to_i+1)/2.0 > 3  
          intake_year = examyear.to_i-((semester.to_i+1)%2)-1#-2
        elsif (semester.to_i+1)/2.0 > 2
          intake_year = examyear.to_i-((semester.to_i+1)%2)#-1
        elsif (semester.to_i+1)/2.0 > 1
          intake_year= examyear
        end  
      end
    end
    intake_year.to_s+'-'+intake_month+'-01'  
  end
 
  def retrieve_student
    Student.where(course_id: programme_id).where('intake=?', intake_group)
  end
  
  #grade points
  def self.total(finale_all,subject_credits)
    @finaletotal = 0.00
    0.upto(finale_all.count-1) do |index|
      @finaletotal = @finaletotal+(finale_all[index]*subject_credits[index])
    end
    @finaletotal
  end
  
  def self.pngs17(finale_total,subject_credits)
    #finale_total/17
    #total_credit = Examresult.get_subjects(programme_id,semester).map(&:credits).inject{|sum,x|sum+x}
    finale_total/(subject_credits.inject{|sum,x|sum+x})
    
    #(subject_credits.inject{|sum,x|sum+x}) 
    #NGS [=finale_total]-> Nilai Gred Semester(JUM-Nilai gred(tiap subjek) * kredit(tiap subjek))
    #PNGS -> Purata Nilai Gred Semester(NGS/jum kredit); [jum kredit=(subject_credits.inject{|sum,x|sum+x})]
  end
  
  def total_credit
    total=0
    retrieve_subject.each do |subject|
      #16Dec2015-Pn Manicka Valli - latest - Pos Basics module code - ADCB 510102 - credit=2
      #credit=subject.code[10,1] if subject.code.size >9
      credit=subject.code[-1,1] #if subject.code.size < 10
      total+=credit.to_i
    end
    total
  end
  
#   def self.total_grade_points(resultlines)
#     total=0
#     if resultlines.first.examresult.total.nil?
#       total+=0
#     else
#       total+=resultlines.first.examresult.total
#     end
#     if resultlines[1].examresult.total.nil?
#       total+=0
#     else
#       total+=resultlines.first.examresult.total
#     end
#     if Programme.where(course_type: 'Diploma').pluck(:id).include?(resultlines.first.examresult.programme_id)
#       if resultlines[2].examresult.total.nil?
#         total+=0
#       else
#         total+=resultlines.first.examresult.total
#       end
#       if resultlines[3].examresult.total.nil?
#         total+=0
#       else
#         total+=resultlines.first.examresult.total
#       end
#       if resultlines[4].examresult.total.nil?
#         total+=0
#       else
#         total+=resultlines.first.examresult.total
#       end
#       if resultlines[5].examresult.total.nil?
#         total+=0
#       else
#         total+=resultlines.first.examresult.total
#       end
#     end
#     total
#   end
  
  #cgpa of ending SEMESTER....
  def self.cgpa_per_sem(resultlines, semester)
    english_subjects=['PTEN', 'NELA', 'NELB', 'NELC', 'MAPE', 'XBRE', 'OTEL'] 
    credit_all_sem=[]
    final_all_sem=[]
    0.upto(semester).each do |cnt|
      subjects=resultlines[cnt].examresult.retrieve_subject
      credit_per_sem=[]
      final_per_sem=[]
      for subject in subjects
        student_finale = Grade.where('student_id=? and subject_id=?', resultlines[cnt].student.id, subject.id).first
        if subject.code.size >9
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            credit_per_sem << subject.code[10,1].to_i
          end
        elsif subject.code.size < 10
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            credit_per_sem << subject.code[-1,1].to_i 
          end
        end
        unless student_finale.nil? || student_finale.blank? 
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            if student_finale.resit==true
	      final_per_sem << student_finale.set_NG2.to_f
	    else
	      final_per_sem << student_finale.set_NG.to_f 
	    end
          end
        else
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            final_per_sem << 0.00
          end
        end
        
      end
      credit_all_sem+=credit_per_sem
      final_all_sem+=final_per_sem
    end
    #total points /  credit
    #final_all_sem.sum/credit_all_sem.sum
    
    #grade points
    #self.total(finale_all,subject_credits)
    Examresult.total(final_all_sem, credit_all_sem) / credit_all_sem.sum
  end
  
  def self.total_grade_points(resultlines)
    english_subjects=['PTEN', 'NELA', 'NELB', 'NELC', 'MAPE', 'XBRE', 'OTEL'] 
    credit_all_sem=[]
    final_all_sem=[]
    totalgradepoints=0
    0.upto(resultlines.count-1).each do |cnt|
      subjects=resultlines[cnt].examresult.retrieve_subject
      credit_per_sem=[]
      final_per_sem=[]
      for subject in subjects
        student_finale = Grade.where('student_id=? and subject_id=?', resultlines[cnt].student.id, subject.id).first
        if subject.code.size >9
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            credit_per_sem << subject.code[10,1].to_i 
          end
        elsif subject.code.size < 10
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            credit_per_sem << subject.code[-1,1].to_i
          end
        end
        unless student_finale.nil? || student_finale.blank? 
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            final_per_sem << student_finale.set_NG.to_f 
          end
        else
          unless english_subjects.include?(subject.code[0,4]) || (subject.code.strip.size < 10 && (subject.code.strip[-2,1].to_i==2 || subject.code.strip[-2,1].to_i==3))
            final_per_sem << 0.00 
          end
        end
      end
      credit_all_sem+=credit_per_sem
      final_all_sem+=final_per_sem
      totalgradepoints+=Examresult.total(final_per_sem, credit_per_sem)
    end
    totalgradepoints     #credit_all_sem.to_s+final_all_sem.to_s
  end
  
end

# == Schema Information
#
# Table name: examresults
#
#  created_at   :datetime
#  examdte      :date
#  examdts      :date
#  id           :integer          not null, primary key
#  pngs17       :decimal(, )
#  programme_id :integer
#  remark       :string(255)
#  semester     :string(255)
#  status       :string(255)
#  total        :decimal(, )
#  updated_at   :datetime
#
