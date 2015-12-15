class Grade < ActiveRecord::Base
  
  validates_presence_of :student_id, :subject_id, :examweight#, :exam1marks #added examweight for multiple edit - same subject - this item must exist
  validates_uniqueness_of :subject_id, :scope => :student_id, :message => " - This student has already taken this subject"
  validates :exam1marks, :finalscore, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
 # validates_presence_of :sent_date, :if => :sent_to_BPL?
  validate :check_formative_valid
  
  belongs_to :studentgrade, :class_name => 'Student', :foreign_key => 'student_id'  #Link to Model student
  belongs_to :subjectgrade, :class_name => 'Programme', :foreign_key => 'subject_id'  #Link to Model subject

  has_many :scores, :dependent => :destroy
  accepts_nested_attributes_for :scores,:allow_destroy => true, :reject_if => lambda { |a| a[:description].blank? } #allow for destroy - 17June2013
  
  #before_save :check_formative_valid
  before_save :apply_finalscore
  
  attr_accessor :intake_id, :marks_70, :formative_weight_sum, :formative_marks_sum, :marks_70_rev

  # define scope
  def self.student_search(query)
    student_ids = Student.where('name ILIKE(?) or matrixno ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id)
    where('student_id IN(?)', student_ids)
  end
  
  def self.subject_search(query)
    subject_ids = Programme.where('(name ILIKE(?) or code ILIKE(?)) and course_type=?', "%#{query}%", "%#{query}%", "Subject").pluck(:id).uniq
    where('subject_id IN(?)', subject_ids)
  end
  
  def self.grading_search(query)
    all_grades = Grade.all
    resu = []
    for grd in all_grades
      resu << grd.id if grd.set_gred==query
    end
    where('id IN(?)', resu)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:student_search, :subject_search, :grading_search]
  end
  
  def apply_finalscore
    unless summative.nil? && formative.nil?
      self.finalscore=summative+formative 
    end
  end
  
  def total_summative
    if subject_id
      # NOTE 
      # Radiografi - exam1marks (100%), total_summative (70%)
      # Cara Kerja - exam1marks=Final Exam(written paper)=(MCQ+SEQ)/(total mcq+total seq), total_summative=(Final Exam*0.70)
      # Pem Peg Perubatan, Fisioterapi - exam1marks=total_formative (70%) -- exam1marks=40%+30% (MCQ+SEQ etc)
      # Pos Basik(KEbidanan) - Summative(60%) : 40%(MCQ) +(MEQ/total meq * 20%)=60%,    JUMLAH BESAR = Formative(40%)+Summative(60%)
    
      # Radiografi - exam1marks (in 100%) - 2 cases: final exam(total) < 100 & > 100
      # Cara Kerja - exam1marks (not really in 100%) - summative calculation same as Radiografi
      diploma=Programme.where(course_type: 'Diploma')
      radiografi=diploma.where('name ILIKE?', '%Radiografi%').first.id
      carakerja=diploma.where('name ILIKE?', '%Jurupulih Perubatan Cara Kerja%').first.id
      if subjectgrade.root_id==radiografi || subjectgrade.root_id==carakerja
        if exam1marks == 0 || exam1marks == nil
          0
        else
          (exam1marks * examweight)/100
        end
      else
        
        #####from formative_contents-7Dec2015
	exist_paper=Exam.where(subject_id: subject_id).order(created_at: :desc).where(name: "F")
        latest_paper=exist_paper.first.id  if exist_paper && exist_paper.count > 0 #Exam.where(subject_id: subject_id).pluck(:id)
        student_exammark=Exammark.where(exam_id: latest_paper).where(student_id: student_id).first
        if student_exammark && Exammark.fullmarks(student_exammark.exam_id)!=70
          student_exammark.total_marks/Exammark.fullmarks(student_exammark.exam_id)*100*0.7
          #####from formative_contents-7Dec2015

        else

          #Pem Peg Perubatan & Fisioterapi - FInal Exam(written papaer) already in 70%
          #Diploma Lanjutan Kebidanan - FInal Exam(written paper) already in 60%
          exam1marks 
        end
      end
    else
      0
    end
  end
  
  def total_summative2
    if subject_id
      # NOTE 
      # Radiografi - exam1marks (100%), total_summative (70%)
      # Cara Kerja - exam1marks=Final Exam(written paper)=(MCQ+SEQ)/(total mcq+total seq), total_summative=(Final Exam*0.70)
      # Pem Peg Perubatan, Fisioterapi - exam1marks=total_formative (70%) -- exam1marks=40%+30% (MCQ+SEQ etc)
      # Pos Basik(KEbidanan) - Summative(60%) : 40%(MCQ) +(MEQ/total meq * 20%)=60%,    JUMLAH BESAR = Formative(40%)+Summative(60%)
    
      # Radiografi - exam1marks (in 100%) - 2 cases: final exam(total) < 100 & > 100
      # Cara Kerja - exam1marks (not really in 100%) - summative calculation same as Radiografi
      diploma=Programme.where(course_type: 'Diploma')
      radiografi=diploma.where('name ILIKE?', '%Radiografi%').first.id
      carakerja=diploma.where('name ILIKE?', '%Jurupulih Perubatan Cara Kerja%').first.id
      if subjectgrade.root_id==radiografi || subjectgrade.root_id==carakerja
        if exam2marks == 0 || exam2marks == nil
          0
        else
          (exam2marks * examweight)/100
        end
      else
        
        #####from formative_contents-7Dec2015
	repeats=Exam.where(subject_id: subject_id).where(name: "R")
        
	if repeats && repeats.count > 0
	  repeat_paper=repeats.first.id
          student_exammark=Exammark.where(exam_id: repeat_paper).where(student_id: student_id).first 
	end
        if student_exammark && Exammark.fullmarks(student_exammark.exam_id)!=70
          student_exammark.total_marks/Exammark.fullmarks(student_exammark.exam_id)*100*0.7
          #####from formative_contents-7Dec2015

        else

          #Pem Peg Perubatan & Fisioterapi - FInal Exam(written papaer) already in 70%
          #Diploma Lanjutan Kebidanan - FInal Exam(written paper) already in 60%
          exam2marks 
        end
      end
    else
      0
    end
  end
  
  def total_per
    Score.where(grade_id: id).sum(:weightage)
  end
    
  def total_formative
    Score.where(grade_id: id).sum(:marks)
  end
  
  def finale
    total_formative+total_summative #8Nov2015
    #score.to_f + total_summative    #23August2013
    #((exam1marks * examweight)/100) + ((total_formative * (100 - examweight)/100))
  end
  
  def finale2
    total_formative+total_summative2
  end
  
  def render_grading
    (DropDown::GRADE.find_all{|disp, value| value == set_gred}).map {|disp, value| disp}[0]
  end
  
  def render_grading2
    (DropDown::GRADE.find_all{|disp, value| value == set_gred2}).map {|disp, value| disp}[0]
  end
  
  def set_gred
    if finale <= 35 
      11#"E"
    elsif finale <= 40
      10#"D"
    elsif finale <= 45
      9#"D+"
    elsif finale <= 50
      8#"C-"
    elsif finale <= 55
      7#"C"
    elsif finale <= 60
      6#"C+"
    elsif finale <= 65
      5#"B-"
    elsif finale <= 70
      4#"B"
    elsif finale <= 75
      3#"B+"
    elsif finale <= 80
      2#"A-"
    else
      1#"A"
    end
  end
  
  def set_gred2
    if finale2 <= 35 
      11#"E"
    elsif finale2 <= 40
      10#"D"
    elsif finale2 <= 45
      9#"D+"
    elsif finale2 <= 50
      8#"C-"
    elsif finale2 <= 55
      7#"C"
    elsif finale2 <= 60
      6#"C+"
    elsif finale2 <= 65
      5#"B-"
    elsif finale2 <= 70
      4#"B"
    elsif finale2 <= 75
      3#"B+"
    elsif finale2 <= 80
      2#"A-"
    else
      1#"A"
    end
  end
  
  def set_NG
    if finale < 35  #<= 35 
      0.00
    elsif finale < 40 #<= 40
      1.00
    elsif finale < 45 #<= 45
      1.33
    elsif finale < 50 #<= 50
      1.67
    elsif finale < 55 #<= 55
      2.00
    elsif finale < 60 #<= 60
      2.33
    elsif finale < 65 #<= 65
      2.67
    elsif finale < 70 #<= 70
      3.00
    elsif finale < 75 #<= 75
      3.33
    elsif finale < 80 #<= 80
      3.67
    else
      4.00
    end
  end 
  
  def set_NG2
    if finale2 < 35  #<= 35 
      0.00
    elsif finale2 < 40 #<= 40
      1.00
    elsif finale2 < 45 #<= 45
      1.33
    elsif finale2 < 50 #<= 50
      1.67
    elsif finale2 < 55 #<= 55
      2.00
    elsif finale2 < 60 #<= 60
      2.33
    elsif finale2 < 65 #<= 65
      2.67
    elsif finale2 < 70 #<= 70
      3.00
    elsif finale2 < 75 #<= 75
      3.33
    elsif finale2 < 80 #<= 80
      3.67
    else
      4.00
    end
  end 
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    posbasics=Programme.where(course_type: ['Pos Basik', 'Diploma Lanjutan', 'Pengkhususan'])
    posbasics_subjects=[]
    posbasics.each{|x|posbasics_subjects+= x.descendants.where(course_type: ['Subject', 'Commonsubject']).pluck(:id)}
    if search 
      if search == '0'
        @grades = Grade.all.order(:subject_id)
      elsif search == '1'
        @grades = Grade.where("subject_id IN (?)", common_subject).order(:subject_id)
      elsif search =='2'
        @grades = Grade.where("subject_id IN (?)", posbasics_subjects).order(:subject_id)
      else
        subject_of_programme = Programme.find(search).descendants.at_depth(2).map(&:id)
        @grades = Grade.where("subject_id IN (?)", subject_of_programme)
      end
    else
       @grades = Grade.all.order(:subject_id)
    end
    #ABOVE : order(:subject_id) - added, when group by subject, won't split up - continueos in paging
  end
  
  private 
  
    def check_formative_valid #add error msg in controller
    if subject_id
       if Programme.roots.where(course_type: 'Diploma').pluck(:id).include?(subjectgrade.root_id)
         if scores && scores.count > 0
           if scores.map(&:weightage).sum > 30 || scores.map(&:marks).sum > 30
	     errors.add(:base, I18n.t('exam.grade.max_weightage_marks_30'))
             #return false
           else
             #return true
           end
         end
       end
    end
    end
  
end