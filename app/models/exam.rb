class Exam < ActiveRecord::Base
  belongs_to  :creator,       :class_name => 'Staff',   :foreign_key => 'created_by'
  #belongs_to  :programme,   :foreign_key => 'course_id'
  belongs_to :subject,  :class_name => 'Programme', :foreign_key => 'subject_id'
  belongs_to :exam_template, :foreign_key => 'topic_id'  #temporary use 'topic_id' field
  belongs_to :college, :foreign_key => 'college_id'
  has_and_belongs_to_many :examquestions
  has_many :exammarks   #11Apr2013
  has_many :examtemplates, :dependent => :destroy #10June2013
  accepts_nested_attributes_for :examtemplates, :reject_if => lambda { |a| a[:quantity].blank? }
  
  before_save :set_sequence, :set_duration, :set_full_marks, :remove_unused_sequence, :set_paper_type, :set_subject_for_repeat #, :set_examtemplates
  before_destroy :valid_for_removal
  after_save :remove_prev_examtemplates
  
  attr_accessor :programme_filter, :subject_filter, :topic_filter, :seq
  
  validates_presence_of :name, :exam_on, :starttime, :endtime
  validates_presence_of :subject_id, :if => :not_repeat_paper?
  validates_presence_of :description, :if => :repeat_paper?
  validates_uniqueness_of :name, :scope => [:subject_id, :name, :exam_on], :message => I18n.t('exam.exams.must_unique')
  validate :sequence_must_be_selected, :sequence_must_be_unique, :must_start_before_end #,:sequence_must_increment_by_one
  
  #remark : validation for:validates_uniqueness_of :name, :scope => "subject_id", 
  #-> exam must unique for each subject, academic session, name(exam type) in full set @ template.
  #eg. Final paper(exam_type) of subject A(subject) for session Jan-Jun2013(academic session) - can EXIST only ONCE (template @ full set).
  
  # define scope
  def self.subject_search(query) 
    subject_ids = Programme.where('(code ILIKE(?) or name ILIKE(?)) and ancestry_depth=?', "%#{query}%", "%#{query}%",2).pluck(:id)
    where('subject_id IN(?)', subject_ids)
  end
  
  def self.programme_search(query)
    programme_ids = Programme.where('(code ILIKE(?) or name ILIKE(?)) and ancestry_depth=?', "%#{query}%", "%#{query}%",0).pluck(:id)
    all_subjects_ids=Exam.all.pluck(:subject_id)
    aa=[]
    all_subjects_ids.each do |sbj|
      if programme_ids.include?(Programme.where(id:sbj).first.root_id)
        aa<< sbj
      end
    end
    where('subject_id IN(?)', aa)
  end
  
  def self.semester_search(query)
    semester_ids = Programme.where(code: "#{query}").pluck(:id)
    all_subjects_ids=Exam.all.pluck(:subject_id)
    bb=[]
    all_subjects_ids.each do |sbj|
      if semester_ids.include?(Programme.where(id:sbj).first.parent_id)
        bb<< sbj
      end
    end
    where('subject_id IN(?)', bb)
  end
  
  def self.complete_search(query)
    query=true if query=='1'
    query=false if query=='0'
    aa=[]
    Exam.all.each{|x|aa << x.id if x.complete_paper==query}
    where(id: aa)
  end
  
  def self.full_marks_search(query)
    et_ids=[]
    ExamTemplate.all.each{|et| et_ids << et.id if et.template_full_marks.to_f==query.to_f}
    where(topic_id: et_ids)
  end
  
  def self.starttime_search(query)
    where('starttime=?', query)
  end
  
  def self.endtime_search(query)
    where('endtime=?', query)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:subject_search, :programme_search, :semester_search, :complete_search, :full_marks_search, :starttime_search, :endtime_search]
  end
  
  def set_sequence
    if seq!= nil
        sequence=""
        seq.each_with_index do |s,index|
            sequence = sequence + s +","
        end
        if examquestion_ids.count > seq.count
            diff_count = examquestion_ids.count - seq.count
            0.upto(diff_count-1) do |c|
                sequence = sequence + I18n.t('select')+","
            end
        end    
        self.sequ = sequence    
    else
      #start-set_sequ_after_create
      if (sequ.nil? || sequ.blank?) && examquestions.count > 0
        seqq=''
        0.upto(examquestions.count-1).each do |x|
          seqq+= I18n.t('select')+','
        end
        self.sequ=seqq
      end
    end
  end

  
  def set_duration
    if starttime!=nil && endtime!=nil
      starthour=starttime.hour*60
      if starttime.min!=nil 
        startminute=starttime.min 
      else
        startminute=0
      end
      endhour=endtime.hour*60
      if endtime.min!=nil 
        endminute=endtime.min 
      else
        endminute=0
      end
      self.duration = ((endhour+endminute) - (starthour+startminute)).to_i
    end
  end
  
  def set_full_marks
    unless id.nil? || id.blank?
      self.full_marks = total_marks
    end
  end
  
  def remove_unused_sequence
    unless id.nil? || id.blank?
      if !sequ.nil? && sequ.split(',').count > examquestions.count
        seqq2=''
        sequ.split(',').each_with_index do |x,index|
          if index < examquestions.count
            seqq2+= x+','
          end
        end
        self.sequ=seqq2
      end 
    end
  end
  
  def set_paper_type
    #require klass_id ==1 to display PDF link
    if examquestions.count > 0 && klass_id.nil?
     self. klass_id=1
    end
  end
  
  def repeat_paper?
    name=="R"
  end
  
  def not_repeat_paper?
    name!="R"
  end
  
  def set_subject_for_repeat
    self.subject_id = Exam.where(id: description.to_i).first.subject_id if description!=nil && name=="R"
  end

  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').map(&:id)
    if search 
      if search == '0'
        @exams = Exam.all
      #elsif search == '1'
        #@exams = Exam.where("subject_id IN (?)", common_subject)
      elsif search == '2'
        postbasic_ids = Programme.where(course_type: ['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan']).pluck(:id).compact
        postbasic_subject_ids = []
        postbasic_ids.each do |pb_id|
          subject_ids=Programme.where(id: pb_id)[0].descendants.at_depth(2).pluck(:id).compact
          postbasic_subject_ids << subject_ids if subject_ids.count > 0
        end
        @exams = Exam.where(subject_id: postbasic_subject_ids)#.where('subject_id NOT IN(?)', common_subject)
      else
        subject_of_programme = Programme.find(search).descendants.at_depth(2).map(&:id)
        @exams=Exam.where(subject_id: subject_of_programme).order('exam_on DESC, subject_id ASC')
        #@exams = Exam.where('subject_id IN(?) AND subject_id NOT IN(?)',subject_of_programme, common_subject).order('exam_on DESC, subject_id ASC')
      end
    end
  end
  
  def creator_details 
    if creator.blank? 
       "None Assigned"
     else 
       creator.name #mykad_with_staff_name
     end
  end
  
  # TODO removed this part - full marks - should retrieve fr Exam Template
  # NOTE - this total_marks refers to FULL MARKS for examination paper - use in exams/_show_exam 
  def total_marks
    # restriction - in exam_template - compulsory field - STANDARD MARKS (marks per question) or TOTAL MARKS
    # NOTE too - each examquestion also have MARKS field
    unless topic_id.nil?
      sum=0
      exam_template.question_count.each do |k, v|

        #if v['count']!='' || v['count']!=nil 
	unless v['count'].blank?
          qty=(v['count']).to_i
          ##if v["full_marks"] && v["full_marks"]!='' || v["full_marks"]!=nil
          #unless v["full_marks"] && v["full_marks"]==''
          if !v["full_marks"].nil? && !v["full_marks"].blank?
            sum1=v["full_marks"].to_f
          else
            if k=="mcq"
              sum1=qty*1 
            elsif k=="seq" || k=="ospe"
              sum1=qty*10
            elsif k=="meq"
              sum1=qty*20
            else
              sum1=qty #default to 1 first
            end
          end
          sum+=sum1
        end

      end
      
    else  # 29 December 2015 - start
      #when template not yet selected?? - no full marks could be count
      sum=0
      # 29 December 2015 - end
    end 
    sum
  end
  
  def render_full_name
    (DropDown::EXAMTYPE.find_all{|disp, value| value == name}).map {|disp, value| disp}[0]
  end  
  
  def exam_name_date
    "#{render_full_name}"+" - "+"#{exam_on.strftime("%d-%B-%Y")}"
  end
  #10Apr2013
  
  def exam_name_subject_date2
     "#{render_full_name} - #{subject.subject_list} (#{subject.root.level.upcase}) - #{exam_on.strftime("%d %B %Y")}"
  end
  
  def exam_name_subject_date
     "#{render_full_name}"+" - "+"#{subject.subject_list}"+" - "+"#{exam_on.strftime("%d %B %Y")}"# +"#{subject.parent.course_type}"
  end
  
  def exam_code_date_type
    if klass_id == 0
      "#{subject.code}"+" | "+"#{exam_on.strftime("%d %b %y")}"+" (#{name}-T)"
    else
      "#{subject.code}"+" | "+"#{exam_on.strftime("%d %b %y")}"+" (#{name})"
    end
  end
  
  def subject_date
    "#{subject.subject_list}"+" - "+"#{exam_on.strftime("%d %b %y")}"
  end
  
  def set_year
    return  "1" if (subject.parent.code == "1") || (subject.parent.code == "2")
    return  "2" if (subject.parent.code == "3") || (subject.parent.code == "4")
    return "3" if (subject.parent.code == "5") || (subject.parent.code == "6")
  end
  
  def set_semester
    return  "1" if (subject.parent.code == "1") || (subject.parent.code == "3")||(subject.parent.code == "5") 
    return  "2" if  (subject.parent.code == "2") || (subject.parent.code == "4") || (subject.parent.code == "6")
  end
  
  def full_exam_name
    "#{render_full_name}"+" - Tahun "+set_year.to_s+", "+"#{subject.parent.course_type}"+" "+set_semester.to_s+" - "+"#{subject.subject_list}"+" - "+"#{exam_on.strftime("%d %B %Y")}"
     #  "#{name}"+" - Tahun "+set_year.to_s+", "+"#{subject.parent.course_type}"+" "+"#{subject.parent.code}"+" - "+"#{subject.subject_list}"+" - "+"#{exam_on.strftime("%d %B %Y")}"
  end
  
  #--12June2013
  
  def render_examtype
    (DropDown::EXAMTYPE.find_all{|disp, value| value == name}).map {|disp, value| disp}
    #(Exam::EXAMTYPE.find_all{|disp, value| value == examtype}).map {|disp, value| disp}
  end
  
  def subject_and_examtype_of_exammaker
    #   "#{Subject.find(subject_id).subject_code_with_subject_name} - #{(Exammaker::EXAMTYPE.find_all{|disp, value| value == examtype}).map {|disp, value| disp}}"
    "#{Programme.find(subject_id).subject_list}"
  end
  
  def subject_of_exammaker
    "#{Programme.find(subject_id).subject_list}"
    #  "#{Subject.find(subject_id).subject_code_with_subject_name} - #{description}"  #exammaker.examination.subject_code_with_subject_name
  end
  
  def programme_of_exammaker
    "#{Programme.find(subject_id).root.programme_coursetype_name }"
  end 
 
  def examtypename
     (DropDown::EXAMTYPE.find_all{|disp, value| value == name}).map {|disp, value| disp}
  	#Exam::EXAMTYPE[("#{name}".to_i)-1][0].to_s	    #Exam::EXAMTYPE[("#{examtype}".to_i)-1][0].to_s	
  end
  
  #--12June2013
  
  def timing
    if college.code=='amsas'
       "#{starttime.try(:strftime, "%H:%M")}"+" - "+"#{endtime.try(:strftime, "%H:%M")}" if starttime!=nil && endtime!=nil
    else
      "#{starttime.try(:strftime, "%l:%M %P")}"+" - "+"#{endtime.try(:strftime, "%l:%M %P")}" if starttime!=nil && endtime!=nil
    end
  end 
  
  def syear 
     if subject_id!=nil && (subject.parent.code == '1' || subject.parent.code == '2')
       studentyear = "1 / " 
     elsif subject_id!=nil && (subject.parent.code == '3' || subject.parent.code == '4')
       studentyear = "2 / "
     elsif subject_id!=nil && (subject.parent.code == '5' || subject.parent.code == '6')
       studentyear = "3 / "
     else
       studentyear = "" #subject.parent.code #rescue for invalid data (parent of subject is semester)
     end
     studentyear
  end
  
  def complete_paper
    unless exam_template.nil?
      if klass_id==0 
        complete=true 
      elsif klass_id==1
        completeness=[]       
        exam_template.question_count.each do |k, v|
          if v['count']!='' 
            qty=(v['count']).to_i
            if k=="mcq"
              if examquestions.mcqq.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="meq"
              if examquestions.meqq.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="seq" 
              if examquestions.seqq.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="acq"
              if examquestions.acqq.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="osci"
              if examquestions.osci2q.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="oscii"
              if examquestions.osci3q.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="osce"
              if examquestions.osceq.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="ospe"
              if examquestions.ospeq.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="viva"
              if examquestions.vivaq.count==qty
                completeness << true
              else
                completeness << false
              end
            elsif k=="truefalse"
              if examquestions.truefalseq.count==qty
                completeness << true
              else
                completeness << false
              end
            end
          end
        end
        complete=true if completeness.include?(false)==false
        complete=false if completeness.include?(false)==true 
       end
    else
      complete=false
    end
    complete
  end
  
#   def ids_complete_exampaper
#     exam_ids_for_examtemplate = Examtemplate.pluck(:exam_id).uniq
#     exam_ids_for_examquestions2 = Exam.joins(:examquestions).map(&:id).uniq 
#     exam_ids_for_examquestions = Exam.where(id: exam_ids_for_examquestions2).pluck(:id).uniq
#     complete_exampaper = Exam.where('id IN (?) OR id IN (?)', exam_ids_for_examtemplate, exam_ids_for_examquestions)
#     ids_complete_exampaper = complete_exampaper.pluck(:id) 
#     ids_complete_exampaper
#   end
  
  def separate_cover
    #[3,5,6,7,8,9,10,11,12,13,14]
    dip_cover=Programme.where('(name=? or name=?) and course_type=?',"Kejururawatan", "Radiografi","Diploma").pluck(:id)
    pb_cover=Programme.where('(name=? or name=? or name=? or name=? or name=? or name=? ) and course_type=?',"Perioperating", "Orthopedik", "Onkologi", "Perawatan Rapi", "Perawatan Renal","Perawatan Psikiatri", "Pos Basik").pluck(:id)
    diplanjut_cover=Programme.where('(name=? or name=?) and course_type=?',
    "Kebidanan", "Pengimejan Perubatan (Pengimejan Payudara)", "Diploma Lanjutan").pluck(:id)
    cover=dip_cover+pb_cover+diplanjut_cover
  end
  
  def combine_cover
    #[1,2,4]
    cover=Programme.where('(name=? or name=? or name=?) and course_type=?', "Jurupulih Perubatan Cara Kerja", "Jurupulih Perubatan Anggota (Fisioterapi)", "Penolong Pegawai Perubatan", "Diploma").pluck(:id)
    cover
  end
  
  def creator_list
    pensyarah = Position.where(name: "Pengajar").pluck(:staff_id)
    lecturer_users = Role.joins(:users).where(name: "Lecturer").pluck(:user_id)
    lecturers = User.where('id IN(?)', lecturer_users).pluck(:userable_id)
    admin_users = Role.joins(:users).where(name: "Administration").pluck(:user_id)
    admins = User.where('id IN(?)', admin_users).pluck(:userable_id)
    creator_ids = pensyarah+lecturers+admins
  end
  
  def valid_for_removal
    finals_of_repeat=Exam.where(name: "R").pluck(:description)
    finals=[]
    finals_of_repeat.each{|y|finals << y.to_i}
    if name=="F" && finals.include?(id)
      return false
    else
      return true
    end
  end
  
  def remove_prev_examtemplates
    if exam_template.nil? && examtemplates
      examtemplates.destroy_all
    end
  end
  
  #use in examanalysis
  def sesi_data
    #sesi data - refer comment by Fisioterapi (Pn Norazebah), note too - Kebidanan intake : Mac / Sept
    #refers to 'academic session' - when the classes / learning & examination takes place).
    diplomas=Programme.roots.where(course_type: 'Diploma')#.pluck(:id)
    posbasiks=Programme.roots.where(course_type: ['Diploma Lanjutan', 'Pos Basik', 'Pengkhususan'])#.pluck(:id)
    diploma_subject_ids=[]
    posbasik_subject_ids=[]
    diplomas.each do |dip|
      dip.descendants.each{|x|diploma_subject_ids << x.id if x.course_type=='Subject'}
    end
    posbasiks.each do |postb|
      postb.descendants.each{|x|posbasik_subject_ids << x.id if x.course_type=='Subject'}
    end
    exam_month=exam_on.month
    exam_year=exam_on.year
    if diploma_subject_ids.include?(subject_id)
      if exam_month <= 6
        sesi="Januari - Jun "+exam_year.to_s
      else
        sesi="Julai - Disember "+exam_year.to_s
      end
    elsif posbasik_subject_ids.include?(subject_id)
      if exam_month > 3 && exam_month <= 9    #inc. 9 when... eg. awal bln exam, akhir bln new intake?
        sesi="Mac - Ogos "+exam_year.to_s
      else
        if exam_month <=3
          sesi="Sept "+(exam_year-1).to_s+" - Februari "+exam_year.to_s
        elsif exam_month > 9
          sesi="Sept "+(exam_year-1).to_s+" - Februari "+(exam_year+1).to_s  #almost impossible Exam held > 2 months be4 semester ended?
        end
      end
    end
    sesi
  end
  
  
  ###########

private

  def sequence_must_increment_by_one
    if seq!= nil
        y=0
        result = true
        seq.sort_by{|k|k.to_i}.each do |x|  #tosort_seqid.sort_by{|k,v|k.to_i}.each do |x,y|  #asalnye:seq.sort.each do |x|
          z=x.to_i
          if y && ((z-y) != 1)
               result = false
          end 
          y=z 
        end
        if result == false && seq.include?(I18n.t('select')) == false                     #sequence increment by 1 can only be checked for selected sequence!
          errors.add(:base, I18n.t('exam.exams.seq_increase_by_one'))  
        end
    end
  end
  
  def sequence_must_be_selected
    if seq!= nil
        if seq.include?(I18n.t('select')) == true  #means sequence not yet selected
          if seq.count < sequ.split(',').count
            errors.add(:base, I18n.t('exam.exams.remove_seq_select'))
          else
            errors.add(:base, I18n.t('exam.exams.seq_must_select'))
          end
        end
    end
  end
  
  def sequence_must_be_unique
    if seq!= nil
        if seq.uniq.length != seq.length && seq.include?(I18n.t('select')) == false       #sequence UNIQUENESS can only be checked for selected sequence!
          errors.add(:base, I18n.t('exam.exams.seq_must_unique'))
        end
    end
  end
  
  def must_start_before_end
    if starttime > endtime
      errors.add(:base, I18n.t('exam.exams.must_start_before_end'))
    end
  end
  
end

# == Schema Information
#
# Table name: exams
#
#  course_id   :integer
#  created_at  :datetime
#  created_by  :integer
#  description :text
#  duration    :integer
#  endtime     :time
#  exam_on     :date
#  full_marks  :integer
#  id          :integer          not null, primary key
#  klass_id    :integer
#  name        :string(255)
#  sequ        :string(255)
#  starttime   :time
#  subject_id  :integer
#  topic_id    :integer
#  updated_at  :datetime
#
