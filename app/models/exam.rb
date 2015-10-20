class Exam < ActiveRecord::Base
  belongs_to  :creator,       :class_name => 'Staff',   :foreign_key => 'created_by'
  belongs_to  :programme,   :foreign_key => 'course_id'
  belongs_to :subject,  :class_name => 'Programme', :foreign_key => 'subject_id'
  has_and_belongs_to_many :examquestions
  has_many :exammarks   #11Apr2013
  has_many :examtemplates, :dependent => :destroy #10June2013
  accepts_nested_attributes_for :examtemplates, :reject_if => lambda { |a| a[:quantity].blank? }
  
  before_save :set_sequence, :set_duration, :set_full_marks, :remove_unused_sequence
  
  attr_accessor :programme_filter, :subject_filter, :topic_filter, :seq
  
  validates_presence_of :subject_id, :name  #programme_id
  validates_uniqueness_of :name, :scope => [:subject_id, :exam_on], :message => I18n.t('exam.exams.must_unique')
  validate :sequence_must_be_selected, :sequence_must_be_unique #,:sequence_must_increment_by_one
  
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

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:subject_search, :programme_search, :semester_search]
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
      if klass_id == 0
        self.full_marks = examtemplates.sum(:total_marks).to_i
      elsif klass_id==1
        self.full_marks = total_marks
      end
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
  
  #def full_marks(exampaper_id)
      #Examquestion.sum(:marks,:joins=>:exammakers, :conditions => ["exammaker_id=?", exampaper_id]).to_f
  #end 
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').map(&:id)
    if search 
      if search == '0'
        @exams = Exam.all
      elsif search == '1'
        @exams = Exam.where("subject_id IN (?)", common_subject)
      else
        subject_of_programme = Programme.find(search).descendants.at_depth(2).map(&:id)
        #@exams = Exam.find(:all, :conditions => ["subject_id IN (?) and subject_id NOT IN (?)", subject_of_program, common_subject])
        @exams = Exam.where('subject_id IN(?) AND subject_id NOT IN(?)',subject_of_programme, common_subject)
      end
    #else
       #@exams = Exam.all
    end
  end
  
  def creator_details 
    if creator.blank? 
       "None Assigned"
     else 
       creator.name #mykad_with_staff_name
     end
  end
  
  #10Apr2013
  def total_marks   #to confirm full marks calculation - based on questiontype & exam paper format..
      sum = Exam.joins(:examquestions).where('exam_id=? and questiontype=?', id, 'MCQ').count 
      seq_count = Exam.joins(:examquestions).where('exam_id=? and questiontype=?', id, 'SEQ').count 
      
      meq_q = Exam.joins(:examquestions).where('exam_id=? and questiontype=?', id, 'MEQ').pluck(:marks)#.map{|x|x.marks}  
      sum_meq=0
      meq_q.each do |t|
        sum_meq+=t.to_i
      end
      acq_q = Exam.joins(:examquestions).where('exam_id=? and questiontype=?', id, 'ACQ').pluck(:marks)#.map{|x|x.marks}  
      sum_acq=0
      acq_q.each do |t|
        sum_acq+=t.to_i
      end 
      osci_q = Exam.joins(:examquestions).where('exam_id=? and questiontype=?', id, 'OSCI').pluck(:marks)#.map{|x|x.marks}  
      sum_osci=0
      osci_q.each do |t|
        sum_osci+=t.to_i
      end
      oscii_q = Exam.joins(:examquestions).where('exam_id=? and questiontype=?', id, 'OSCII').pluck(:marks)#.map{|x|x.marks}  
      sum_oscii=0 
      oscii_q.each do |t|
        sum_oscii+=t.to_i
      end
      sum=sum+sum_meq+sum_acq+sum_osci+sum_oscii
      sum=sum+(seq_count)*10 if seq_count > 0
      return sum
  end
  
  def render_full_name
    (DropDown::EXAMTYPE.find_all{|disp, value| value == name}).map {|disp, value| disp}[0]
  end  
  
  def exam_name_date
    "#{render_full_name}"+" - "+"#{exam_on.strftime("%d-%B-%Y")}"
  end
  #10Apr2013
  
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
    "#{starttime.try(:strftime, "%l:%M %P")}"+" - "+"#{endtime.try(:strftime, "%l:%M %P")}" if starttime!=nil && endtime!=nil
  end 
  
  def syear 
     if subject_id!=nil && (subject.parent.code == '1' || subject.parent.code == '2')
       studentyear = "1 / " 
     elsif subject_id!=nil && (subject.parent.code == '3' || subject.parent.code == '4')
       studentyear = "2 / "
     elsif subject_id!=nil && (subject.parent.code == '5' || subject.parent.code == '6')
       studentyear = "3 / "
     end
     studentyear
  end
  
  def ids_complete_exampaper
    exam_ids_for_examtemplate = Examtemplate.pluck(:exam_id).uniq
    exam_ids_for_examquestions = Exam.joins(:examquestions).map(&:id).uniq 
    complete_exampaper = Exam.where('id IN (?) OR id IN (?)', exam_ids_for_examtemplate, exam_ids_for_examquestions)
    ids_complete_exampaper = complete_exampaper.pluck(:id) 
    ids_complete_exampaper
  end
  
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
