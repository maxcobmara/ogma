class ExamTemplate < ActiveRecord::Base
  serialize :data, Hash

  def question_count=(value)
    data[:question_count] = value
  end
  def question_count
    data[:question_count]
  end

end
