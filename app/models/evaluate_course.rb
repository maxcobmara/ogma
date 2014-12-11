class EvaluateCourse < ActiveRecord::Base
  belongs_to :studentevaluate,   :class_name => 'Student',   :foreign_key => 'student_id'
  belongs_to :stucourse,         :class_name => 'Programme', :foreign_key => 'course_id'
  belongs_to :subjectevaluate,   :class_name => 'Programme',   :foreign_key => 'subject_id'
  belongs_to :staffevaluate,     :class_name => 'Staff',     :foreign_key => 'staff_id'
  
  validates_presence_of :evaluate_date, :course_id, :subject_id, :ev_obj, :ev_knowledge, :ev_deliver, :ev_content, :ev_tool, :ev_topic, :ev_work, :ev_note#,:student_id 
  
  validate :validate_staff_or_invitation_lecturer_must_exist
  
  # define scope
  def self.programme_subject_search(query) 
    prog_ids=Programme.where('name ILIKE (?) and ancestry_depth=?', "#{query}", 0).pluck(:id)
    sub_ids=Programme.where('(name ILIKE(?) or code ILIKE(?)) and course_type=?', "%#{query}%", "%#{query}%", "Subject").pluck(:id)
    where('course_id IN(?) or subject_id IN(?)', prog_ids, sub_ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:programme_subject_search]
  end  
  
  def lecturer_subject_evaluate
    "#{lecturer_evaluate} | #{subject_evaluate} "
  end
  
  def lecturer_evaluate
    if staffevaluate.blank?
      "-"
    else
      #staffevaluate.staff_name_with_title
      staffevaluate.name
    end
  end
  
  def lecturer_evaluate_icno
     if staffevaluate.blank?
       "-"
     else
       staffevaluate.formatted_mykad
     end
   end
   
   def lecturer_evaluate_rank
      if staffevaluate.blank?
        "-"
      else
        staffevaluate.position_for_staff
      end
    end
  
  def course_evaluate
    if stucourse.blank?
      "-"
    else
      stucourse.programme_coursetype_name
    end
  end
  
  def course_type_evaluate
     if stucourse.blank?
       "-"
     else
       stucourse.specialisation
     end
  end
  
  def subject_evaluate
    if subjectevaluate.blank?
      "-"
    else
      subjectevaluate.name
    end
  end
  
  def evaluate_detail
    "#{course_evaluate} | #{lecturer_evaluate} | #{subject_evaluate} "
  end
  
  def self.search2(programmeid)
    if programmeid.is_a? String
      userable_id = programmeid.split(",")[1]
      evaluate_courses = EvaluateCourse.where(student_id: userable_id)
    else
      if programmeid==0
        evaluate_courses = EvaluateCourse.all
      else
        evaluate_courses = EvaluateCourse.where(course_id: programmeid)
      end
    end
    evaluate_courses
  end
  
  private
    def validate_staff_or_invitation_lecturer_must_exist
      if (staff_id.nil? || staff_id.blank?) && (invite_lec.nil? || invite_lec.blank?)
        errors.add(I18n.t('exam.evaluate_course.staff_id'), I18n.t('exam.evaluate_course.staff_invitation_must_exist')) 
      end 
    end
  
  
end
