class InstructorAppraisal < ActiveRecord::Base
  before_save :update_total
  belongs_to :checker, class_name: 'Staff', foreign_key: 'check_qc'
  belongs_to :instructor, class_name: 'Staff', foreign_key: 'staff_id'
  validates :check_qc, presence: true, :if => :appraisal_sent?
  
  def appraisal_sent?
    qc_sent==true
  end
  
  def update_total
    self.total_mark= totalscore
  end

  def totalscore
    	  q1 + q2 + q3 + q4 + q5 + q6 + q7 + q8 + q9 + q10 + 
    	  q11 + q12 + q13 + q14 + q15 + q16 + q17 + q18 + q19 + q20 + 
    	  q21 + q22 + q23 + q24 + q25 + q26 + q27 + q28 + q29 + q30 + 
    	  q31 + q32 + q33 + q34 + q35 + q36 + q37 + q38 + q39 + q40 + 
    	  q41 + q42 + q43 + q44 + q45 + q46 + q47 + q48
  end
end
