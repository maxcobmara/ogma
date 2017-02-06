class InstructorAppraisal < ActiveRecord::Base
  
  before_save :update_total
  belongs_to :college
  belongs_to :checker, class_name: 'Staff', foreign_key: 'check_qc'
  belongs_to :instructor, class_name: 'Staff', foreign_key: 'staff_id'
  validates :staff_id, :appraisal_date, presence: true
  validates :check_qc, presence: true, :if => :appraisal_sent?
  validates :check_date, presence: true, :if => :appraisal_checked?
  validate :one_per_quarter

  serialize :data, Hash

  def q1=(value)
    data[:q1] = value
  end
  def q1
    data[:q1]
  end 
  
  def q2=(value)
    data[:q2] = value
  end
  def q2
    data[:q2]
  end 
  
  def q3=(value)
    data[:q3] = value
  end
  def q3
    data[:q3]
  end 
  
  def q4=(value)
    data[:q4] = value
  end
  def q4
    data[:q4]
  end 
  
  def q5=(value)
    data[:q5] = value
  end
  def q5
    data[:q5]
  end 
    
  def q6=(value)
    data[:q6] = value
  end
  def q6
    data[:q6]
  end 
  
  def q7=(value)
    data[:q7] = value
  end
  def q7
    data[:q7]
  end 
  
  def q8=(value)
    data[:q8] = value
  end
  def q8
    data[:q8]
  end 
  
  def q9=(value)
    data[:q9] = value
  end
  def q9
    data[:q9]
  end 
  
  def q10=(value)
    data[:q10] = value
  end
  def q10
    data[:q10]
  end 
  ###
  def q11=(value)
    data[:q11] = value
  end
  def q11
    data[:q11]
  end 
  
  def q12=(value)
    data[:q12] = value
  end
  def q12
    data[:q12]
  end 
  
  def q13=(value)
    data[:q13] = value
  end
  def q13
    data[:q13]
  end 
  
  def q14=(value)
    data[:q14] = value
  end
  def q14
    data[:q14]
  end 
  
  def q15=(value)
    data[:q15] = value
  end
  def q15
    data[:q15]
  end 
    
  def q16=(value)
    data[:q16] = value
  end
  def q16
    data[:q16]
  end 
  
  def q17=(value)
    data[:q17] = value
  end
  def q17
    data[:q17]
  end 
  
  def q18=(value)
    data[:q18] = value
  end
  def q18
    data[:q18]
  end 
  
  def q19=(value)
    data[:q19] = value
  end
  def q19
    data[:q19]
  end 
  
  def q20=(value)
    data[:q20] = value
  end
  def q20
    data[:q20]
  end 
  
  ###
  def q21=(value)
    data[:q21] = value
  end
  def q21
    data[:q21]
  end 
  
  def q22=(value)
    data[:q22] = value
  end
  def q22
    data[:q22]
  end 
  
  def q23=(value)
    data[:q23] = value
  end
  def q23
    data[:q23]
  end 
  
  def q24=(value)
    data[:q24] = value
  end
  def q24
    data[:q24]
  end 
  
  def q25=(value)
    data[:q25] = value
  end
  def q25
    data[:q25]
  end 
    
  def q26=(value)
    data[:q26] = value
  end
  def q26
    data[:q26]
  end 
  
  def q27=(value)
    data[:q27] = value
  end
  def q27
    data[:q27]
  end 
  
  def q28=(value)
    data[:q28] = value
  end
  def q28
    data[:q28]
  end 
  
  def q29=(value)
    data[:q29] = value
  end
  def q29
    data[:q29]
  end 
  
  def q30=(value)
    data[:q30] = value
  end
  def q30
    data[:q30]
  end 
  
  ###
  def q31=(value)
    data[:q31] = value
  end
  def q31
    data[:q31]
  end 
  
  def q32=(value)
    data[:q32] = value
  end
  def q32
    data[:q32]
  end 
  
  def q33=(value)
    data[:q33] = value
  end
  def q33
    data[:q33]
  end 
  
  def q34=(value)
    data[:q34] = value
  end
  def q34
    data[:q34]
  end 
  
  def q35=(value)
    data[:q35] = value
  end
  def q35
    data[:q35]
  end 
    
  def q36=(value)
    data[:q36] = value
  end
  def q36
    data[:q36]
  end 
  
  def q37=(value)
    data[:q37] = value
  end
  def q37
    data[:q37]
  end 
  
  def q38=(value)
    data[:q38] = value
  end
  def q38
    data[:q38]
  end 
  
  def q39=(value)
    data[:q39] = value
  end
  def q39
    data[:q39]
  end 
  
  def q40=(value)
    data[:q40] = value
  end
  def q40
    data[:q40]
  end 
  
  ###
  def q41=(value)
    data[:q41] = value
  end
  def q41
    data[:q41]
  end 
  
  def q42=(value)
    data[:q42] = value
  end
  def q42
    data[:q42]
  end 
  
  def q43=(value)
    data[:q43] = value
  end
  def q43
    data[:q43]
  end 
  
  def q44=(value)
    data[:q44] = value
  end
  def q44
    data[:q44]
  end 
  
  def q45=(value)
    data[:q45] = value
  end
  def q45
    data[:q45]
  end 
    
  def q46=(value)
    data[:q46] = value
  end
  def q46
    data[:q46]
  end 
  
  def q47=(value)
    data[:q47] = value
  end
  def q47
    data[:q47]
  end 
  
  def q48=(value)
    data[:q48] = value
  end
  def q48
    data[:q48]
  end 

  def appraisal_sent?
    qc_sent==true
  end
  
  def appraisal_checked?
    checked==true
  end
  
  def update_total
    self.total_mark= totalscore
  end

  def totalscore
    	  q1.to_i + q2.to_i + q3.to_i + q4.to_i + q5.to_i + q6.to_i + q7.to_i + q8.to_i + q9.to_i + q10.to_i + 
    	  q11.to_i + q12.to_i + q13.to_i + q14.to_i + q15.to_i + q16.to_i + q17.to_i + q18.to_i + q19.to_i + q20.to_i + 
    	  q21.to_i + q22.to_i + q23.to_i + q24.to_i + q25.to_i + q26.to_i + q27.to_i + q28.to_i + q29.to_i + q30.to_i + 
    	  q31.to_i + q32.to_i + q33.to_i + q34.to_i + q35.to_i + q36.to_i + q37.to_i + q38.to_i + q39.to_i + q40.to_i + 
    	  q41.to_i + q42.to_i + q43.to_i + q44.to_i + q45.to_i + q46.to_i + q47.to_i + q48.to_i
  end
  
  def level
    return I18n.t('instructor_appraisal.good').split("-")[1] if total_mark>=90
    return I18n.t('instructor_appraisal.satisfactory').split("-")[1] if total_mark<90 && total_mark>64
    return I18n.t('instructor_appraisal.unsatisfactory').split("-")[1] if total_mark<65
  end
  
  def self.search2(search)
    if search
      where('staff_id=? OR check_qc=?', search, search)
    end
  end
  
  private
  
    def one_per_quarter
      #http://stackoverflow.com/questions/9428605/find-number-of-months-between-two-dates-in-ruby-on-rails
      #(date2.year * 12 + date2.month) - (date1.year * 12 + date1.month) 
      if id.nil? && staff_id 
        last_evaluation=InstructorAppraisal.where(staff_id: staff_id).last.appraisal_date
        diff_current_last=(appraisal_date.year * 12 + appraisal_date.month) - (last_evaluation.year * 12 + last_evaluation.month)
        if diff_current_last < 3
          errors.add(:appraisal_date, I18n.t('instructor_appraisal.one_per_quarter')+last_evaluation.strftime('%d-%m-%Y')+".")
        end
      end
    end
    
end
