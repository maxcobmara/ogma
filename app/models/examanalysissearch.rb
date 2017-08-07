class Examanalysissearch < ActiveRecord::Base
  attr_accessor :programme_details
  
  before_save :update_programme
  
  belongs_to :college
  
  def examanalyses
    @examanalyses ||= find_examanalyses
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

    def find_examanalyses
      Examanalysis.where(conditions).order(orders)   
    end
    
    def subject_id_conditions
      unless subject_id.blank?
        exam_ids= Exam.where('subject_id=?', subject_id).map(&:id).uniq
        if exam_ids.count > 0
          a="exam_id=? " 
          0.upto(exam_ids.count-2).each do |x|
            a+=" OR exam_id=? " if exam_ids.count > 1
          end
          ["("+a+")", exam_ids] 
        else
          ["exam_id=?", nil]
        end
      end
    end
  
    #ignore programme_id if subject_id exist
    def programme_id_conditions
      unless programme_id.blank? 
        if subject_id.blank?
          subject_ids=Programme.find(programme_id).descendants.where(course_type: 'Subject').pluck(:id)
          exam_ids= Exam.where(subject_id: subject_ids).map(&:id).uniq
          if exam_ids.count > 0
            a="exam_id=? " 
            0.upto(exam_ids.count-2).each do |x|
              a+=" OR exam_id=? " if exam_ids.count > 1
            end
            ["("+a+")", exam_ids]  
          else
            ["exam_id=?", nil]
          end
        end
      end
    end
  
    def examon_conditions
      unless examon.blank?
        exam_ids=Exam.where('exam_on=?',examon).map(&:id).uniq
        if exam_ids.count > 0
          a='exam_id=? ' 
          0.upto(exam_ids.count-2) do |l|  
            a=a+'OR exam_id=? ' if exam_ids.count > 1
          end 
          [" ("+a+")", exam_ids]
        else
          ["exam_id=?", nil]
        end
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
