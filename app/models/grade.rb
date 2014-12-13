class Grade < ActiveRecord::Base
  
  validates_presence_of :student_id, :subject_id, :examweight#, :exam1marks #added examweight for multiple edit - same subject - this item must exist
  validates_uniqueness_of :subject_id, :scope => :student_id, :message => " - This student has already taken this subject"
  
  belongs_to :studentgrade, :class_name => 'Student', :foreign_key => 'student_id'  #Link to Model student
  belongs_to :subjectgrade, :class_name => 'Programme', :foreign_key => 'subject_id'  #Link to Model subject

  has_many :scores, :dependent => :destroy
  accepts_nested_attributes_for :scores,:allow_destroy => true, :reject_if => lambda { |a| a[:description].blank? } #allow for destroy - 17June2013

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
  
  def total_summative
    if exam1marks == 0
      0
    else
      (exam1marks * examweight)/100
    end
  end
  
  def finale
    score.to_f + total_summative    #23August2013
    #((exam1marks * examweight)/100) + ((total_formative * (100 - examweight)/100))
  end
  
  def set_gred
    if finale <= 35 
      "E"
    elsif finale <= 40
      "D"
    elsif finale <= 45
      "D+"
    elsif finale <= 50
      "C-"
    elsif finale <= 55
      "C"
    elsif finale <= 60
      "C+"
    elsif finale <= 65
      "B-"
    elsif finale <= 70
      "B"
    elsif finale <= 75
      "B+"
    elsif finale <= 80
      "A-"
    else
      "A"
    end
  end
  
  def self.search2(search)
    common_subject = Programme.where('course_type=?','Commonsubject').pluck(:id)
    if search 
      if search == '0'
        @grades = Grade.all
      elsif search == '1'
        @grades = Grade.where("subject_id IN (?)", common_subject)
      else
        subject_of_programme = Programme.find(search).descendants.at_depth(2).map(&:id)
        @grades = Grade.where("subject_id IN (?)", subject_of_programme)
      end
    else
       @grades = Grade.all
    end
  end
  
end