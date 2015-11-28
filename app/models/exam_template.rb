class ExamTemplate < ActiveRecord::Base
  serialize :data, Hash

  belongs_to  :creator,       :class_name => 'User',   :foreign_key => 'created_by'

  def question_count=(value)
    data[:question_count] = value
  end
  def question_count
    data[:question_count]
  end

end
