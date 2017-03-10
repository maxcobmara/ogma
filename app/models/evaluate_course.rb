class EvaluateCourse < ActiveRecord::Base
  belongs_to :college
  belongs_to :studentevaluate,   :class_name => 'Student',   :foreign_key => 'student_id'
  belongs_to :stucourse,         :class_name => 'Programme', :foreign_key => 'course_id'
  belongs_to :subjectevaluate,   :class_name => 'Programme',   :foreign_key => 'subject_id'
  belongs_to :staffevaluate,     :class_name => 'Staff',     :foreign_key => 'staff_id'
  belongs_to :visitor
  
  validates_presence_of :evaluate_date, :course_id, :ev_obj, :ev_knowledge, :ev_deliver, :ev_content, :ev_tool, :ev_topic, :ev_work, :ev_note, :ev_assessment, :student_id
  validate :validate_staff_or_invitation_lecturer_must_exist
  validates_presence_of :subject_id, :if => :trainer_is_staff?
  validates_presence_of :invite_lec_topic, :if => :trainer_invited?
  validates_uniqueness_of :staff_id, :scope =>[:subject_id, :student_id], :message => I18n.t("exam.evaluate_course.evaluation_once")
  
  attr_accessor :is_staff    #kskbjb - staff vs invitation lecturer, amsas - module/subject select OR topic entered manually
  
  # define scope
  def self.programme_subject_search(query) 
    prog_ids=Programme.where('name ILIKE (?) and ancestry_depth=?', "%#{query}%", 0).pluck(:id)
    sub_ids=Programme.where('(name ILIKE(?) or code ILIKE(?)) and course_type=?', "%#{query}%", "%#{query}%", "Subject").pluck(:id)
    where('course_id IN(?) or subject_id IN(?) or invite_lec_topic ILIKE(?)', prog_ids, sub_ids, "%#{query}%")
  end
  
  def self.evaluated_search(query)
    staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    where('staff_id IN(?) or invite_lec ILIKE(?)', staff_ids, "%#{query}%")
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:programme_subject_search, :evaluated_search]
  end  
  
  def trainer_is_staff?
    !staff_id.blank?
  end
  
  def trainer_invited?
    !invite_lec.blank?
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
      elsif programmeid==2
        posbasic_ids=Programme.roots.where(course_type: ['Pos Basik', 'Pengkhususan', 'Diploma Lanjutan']).pluck(:id)
        evaluate_courses= EvaluateCourse.where(course_id: posbasic_ids)
      else
        evaluate_courses = EvaluateCourse.where(course_id: programmeid)
      end
    end
    evaluate_courses
  end
  
  def self.lecturer_list(programmeid, programmename)
    diploma_ids=Programme.roots.where(course_type: "Diploma").pluck(:id)
    posbasik=Programme.roots.where(course_type: ["Diploma lanjutan", "Pos Basik", "Pengkhususan"])
    if diploma_ids.include?(programmeid)
      @lecturer_list = Staff.joins(:positions).where('positions.name=? and unit=?', "Pengajar", programmename)
    elsif posbasik.pluck(:id).include?(programmeid)
      posbasik_names=posbasik.pluck(:name)
      posbasik_positions=Position.where(unit: ["Diploma lanjutan", "Pos Basik", "Pengkhususan"])
      @lecturer_ids=[]
      posbasik_positions.each do |post|
        posbasik_names.each do |pname|
          @lecturer_ids << post.staff_id if post.tasks_main.include?(pname)
        end
      end
      @lecturer_list=Staff.joins(:positions).where('positions.name=? and staff_id IN(?)', "Pengajar", @lecturer_ids.uniq).uniq
    end
    @lecturer_list
  end
  
  private
    def validate_staff_or_invitation_lecturer_must_exist
      if (staff_id.nil? || staff_id.blank?) && (invite_lec.nil? || invite_lec.blank?)
        errors.add(I18n.t('exam.evaluate_course.staff_id'), I18n.t('exam.evaluate_course.staff_invitation_must_exist')) 
      end 
    end
  
  
end
