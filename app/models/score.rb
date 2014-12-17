class Score < ActiveRecord::Base

  before_save :save_my_vars  
  belongs_to :grade

  validates_presence_of :description

  def save_my_vars
    self.score = type_marks
  end 

  def type_marks
    (marks * weightage)/100 if marks!=nil
  end

end
