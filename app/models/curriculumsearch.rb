class Curriculumsearch < ActiveRecord::Base
  belongs_to :college
  
  def curriculums
    @curriculums ||= find_curriculums
  end
  
  private

  def find_curriculums
    Programme.where(conditions).order(orders)   
  end
  
  def programme_id_conditions
    ["id=?", programme_id] unless programme_id.blank?
  end
  
  def semester_conditions
    ["id=?", semester] unless semester.blank?
  end
   
  #shared descendants_ids (for subject & topic)
  def descendants_ids
    unless semester.blank?
      desc_ids = Programme.find(semester).descendants.map(&:id)
    else
      if programme_id.blank?
        a=[]
        Programme.roots.each{|x|a+= x.descendants.map(&:id)}
        desc_ids=a.compact
      else
        desc_ids = Programme.find(programme_id).descendants.map(&:id).compact
      end
    end
    desc_ids
  end

  def subject_conditions
    if (!semester.blank? && subject==1) || (programme_id.blank?)
      #selection1 (programme_id+semester(modul)+subject) OR selection2(no selection)
      subjects_ids = Programme.where('id IN(?) and (course_type=? or course_type=?)', descendants_ids, 'Subject', 'Commonsubject')
    elsif (!programme_id.blank? && subject==0)
      #inc Module here, selection (programme_id only)
      subjects_ids = Programme.where(id: descendants_ids).where(course_type: ['Subject', 'Commonsubject', 'Module']) 
    end
    if subjects_ids.count > 0
      a="id=?"
      0.upto(subjects_ids.count-2).each do |y|
        a+=" OR id=? " if subjects_ids.count > 1
      end
      [a, subjects_ids] if ((!semester.blank? && subject==1) || (!programme_id.blank? && semester.blank? && subject==0))      
    end
  end
   
  def topic_conditions
    topics_ids = Programme.where('id IN(?) and (course_type=? or course_type=?)', descendants_ids, 'Topic', 'Subtopic')
    if topics_ids.count > 0
      a="id=?"
      0.upto(topics_ids.count-2).each do |y|
        a+=" OR id=? " if topics_ids.count > 1
      end
      [a, topics_ids] if ((!semester.blank? && subject==1 && topic==1) || (!programme_id.blank? && semester.blank? && subject==0 && topic==0))
    end
  end  
  
  def orders
    "combo_code ASC"
  end  

  def conditions  #Use OR operator instead of AND operator
    [conditions_clauses.join(' OR '), *conditions_options] 
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
