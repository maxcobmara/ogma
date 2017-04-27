class Studentattendancesearch < ActiveRecord::Base
#   attr_accessible :schedule_id, :intake_id, :student_id
  attr_accessor :method, :course_id
  
  belongs_to :college
  
  validate :intake_id, presence: true, :if => :programme_is_selected
  
  def studentattendances
    @studentattendances ||= find_studentattendances
  end
  
  def programme_is_selected
    course_id.blank? == false
  end
  
  private

  def find_studentattendances
    StudentAttendance.where(conditions).order(orders)   
  end

  def schedule_id_conditions
    ["weeklytimetable_details_id=?", schedule_id] unless schedule_id.blank?      
  end

  # TODO - kskbjb - replace usage of intake with intake_id first
  def intake_id_details
      a='student_id=? ' if Student.where('intake_id=?', intake_id).count!=0
      0.upto(Student.where('intake_id=?', intake_id).count-2) do |l|  
        a=a+'OR student_id=? '
      end 
      return a unless intake_id.blank?
  end  
  
  def intake_id_conditions
    [intake_id_details, Student.where('intake_id=?', intake_id)] unless intake_id.blank?
  end
  
  def student_id_conditions
    if college.code=='amsas'
      ["student_id=?", Student.where('icno ILIKE (?)', "%#{student_id}%")] unless student_id.blank?  #using autocomplete - to retrieve part of/full icno
    elsif college.code=='kskbjb'
    ["student_id=?",Student.where('matrixno=?', student_id.to_s).first.id] unless student_id.blank?    #matrixno (in STUDENT table)
    #["student_id=?",student_id] unless student_id.blank?   #student_id (in STUDENT table)
    end
  end
 
  def orders
    "id ASC"
  end  

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
end
