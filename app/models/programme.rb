class Programme < ActiveRecord::Base
  before_save :set_combo_code
  has_ancestry :cache_depth => true

  #scope :by_semester, -> { where(course_type: 'Semester')}
  def code2
    code.to_i
  end
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    else
      self.combo_code = parent.combo_code + "-" + code
    end
  end
  
  def tree_nd
    if is_root?
      gls = ""
    else
      gls = "class=\"child-of-node-#{parent_id}\""
    end
    gls
  end
  
  def subject_list
      "#{code}" + " " + "#{name}"   
  end
  
  def programme_list
    if is_root?
      "#{course_type}" + " " + "#{name}"   
    else
    end
  end
  
  def semester_subject_topic
    if ancestry_depth == 3
      "Sem #{parent.parent.code}"+"-"+"#{parent.code}"+" | "+"#{name}"
    elsif ancestry_depth == 4
      ">>Sem #{parent.parent.parent.code}"+"-"+"#{parent.parent.code}"+" | "+"#{code} "+"#{name}"
    end
  end
  
  def code_course_type_name  #for subject, topic & subtopic in Tree View
    "#{code} #{course_type} #{name}"
  end
  
end

# == Schema Information
#
# Table name: programmes
#
#  ancestry       :string(255)
#  ancestry_depth :integer
#  code           :string(255)
#  combo_code     :string(255)
#  course_type    :string(255)
#  created_at     :datetime
#  credits        :integer
#  duration       :integer
#  duration_type  :integer
#  id             :integer          not null, primary key
#  name           :string(255)
#  objective      :text
#  status         :integer
#  updated_at     :datetime
#
