class Evaluatecoursesearch < ActiveRecord::Base
  attr_accessor :programme_details
  
  before_save :update_programme
  
  belongs_to :college
  
  def evaluatecourses
    @evaluatecourses ||= find_evaluatecourses
  end
  
  # TODO - check against kskb data 
  def update_programme
    unless subject_id.blank?
      self.programme_id=Programme.find(subject_id).root_id
    else
      ##when subject is not selected
      unless programme_details.blank?
        a=programme_details.split(" (")[0]
        b=programme_details.split(" ")[0]+" "
        c=a.gsub!(b,"")
        programmeid=Programme.where(name: c).first.id
        self.programme_id=programmeid
      end
    end
  end
  
  private

  def find_evaluatecourses
    EvaluateCourse.where(conditions).order(orders)   
  end

  def programme_id_conditions
    ["course_id=?", programme_id] unless programme_id.blank?      
  end
  
  def programme_id2_conditions
    ["course_id=?", programme_id2] unless programme_id2.blank?   
  end
  
  def is_staff_conditions
    if is_staff==false
      aa=["staff_id is null"] #for checking  aa=["visitor_id is not null"]
    elsif is_staff==true
      aa=["staff_id is not null"]
    end 
    return aa if is_staff==true || is_staff==false
  end
  
  def visitor_id_conditions
    ["visitor_id=?", visitor_id] unless visitor_id.blank?
  end
  
  def subject_id_conditions
    ["subject_id=?", subject_id] unless subject_id.blank?      
  end
  
  def evaldate_conditions
    ["evaluate_date>=?", evaldate] unless evaldate.blank?      
  end
  
  def evaldate_end_conditions
    ["evaluate_date<=?", evaldate_end] unless evaldate_end.blank?      
  end
  
  def lecturer_id_conditions
    ["staff_id=?", lecturer_id] unless lecturer_id.blank?      
  end
  
  def orders
     "course_id, subject_id, evaluate_date, staff_id ASC"
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
