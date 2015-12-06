class ExamTemplate < ActiveRecord::Base
  serialize :data, Hash

  belongs_to  :creator,       :class_name => 'User',   :foreign_key => 'created_by'
  has_many :exams
  
  before_destroy :valid_for_removal
  
  def question_count=(value)
    data[:question_count] = value
  end
  def question_count
    data[:question_count]
  end
  
  # define scope
  def self.creator_search(query) 
    staff_ids = Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    user_ids = User.where(userable_id: staff_ids).pluck(:id)
    where(created_by: user_ids)
  end
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:creator_search]
  end
  
  def valid_for_removal
    if Exam.where(topic_id: id).count > 0
      return false
    else
      return true
    end
  end

end
