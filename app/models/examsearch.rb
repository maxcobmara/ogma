class Examsearch < ActiveRecord::Base
  attr_accessor :programme_details
  
  before_save :update_programme
  
  belongs_to :college
  
  def exams
    @examsearch ||= find_exams
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

   def find_exams
      Exam.where(conditions).order(orders)   
   end
   
   def valid_papertype_conditions
     ["klass_id is not null"] if valid_papertype==1
   end
  
   def programme_id_conditions
     unless programme_id.blank?
       subject_ids_in_exams = Exam.where('klass_id is not null').map(&:subject_id)
       prog_descendants=Programme.find(programme_id).descendants.map(&:id)
       subject_ids = Programme.where('id IN(?) and id IN(?)', subject_ids_in_exams, prog_descendants).map(&:id)
       a="subject_id=? " if subject_ids.count > 0
       0.upto(subject_ids.count-2).each do |x|
         a+=" OR subject_id=? " 
       end
     end
     ["("+a+")", subject_ids] unless programme_id.blank?  
   end
  
   def subject_id_conditions
     ["subject_id=?", subject_id] unless subject_id.blank?
   end
  
   def examtype_conditions
     ["name=?", examtype.split("-")[0]] unless examtype.blank?
   end
   
   def created_by_conditions
     ["created_by=?", created_by] unless created_by.blank?
   end
   
   def klass_id_conditions
     ["klass_id=?", klass_id] unless klass_id.blank?
   end
   
   def examdate_conditions
     ["exam_on=?", examdate] unless examdate.blank?
   end
  
  def orders
    "exam_on DESC"
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
