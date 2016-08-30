class AverageInstructor < ActiveRecord::Base
  
  belongs_to :instructor, class_name: 'Staff', foreign_key: 'instructor_id'
  belongs_to :programme, class_name: 'Programme', foreign_key: 'programme_id'
  belongs_to :evaluator, class_name: 'Staff', foreign_key: 'evaluator_id'
  
  validates :instructor_id, :evaluator_id,:delivery_type, :evaluate_date, :start_at, :end_at, :pbq1,:pbq2,:pbq3,:pbq4,:pdq1,:pdq2,:pdq3,:pdq4,:pdq5,:dq1,:dq2,:dq3, :dq4,:dq5,:dq6,:dq7, :dq8,:dq9,:dq10,:dq11,:dq12, :uq1,:uq2,:uq3,:uq4,:vq1,:vq2,:vq3,:vq4,:vq5,:gttq1,:gttq2,:gttq3,:gttq4,:gttq5,:gttq6,:gttq7,:gttq8,:gttq9, presence: true
  
    def marks_a
      pbq1+pbq2+pbq3+pbq4+pdq1+pdq2+pdq3+pdq4+pdq5
    end

    def marks_b
      dq1+dq2+dq3+dq4+dq5+dq6+dq7+dq8+dq9+dq10+dq11+dq12
    end
    
    def marks_c
      uq1+uq2+uq3+uq4
    end
    
    def marks_d
      vq1+vq2+vq3+vq4+vq5
    end
    
    def marks_e
      gttq1+gttq2+gttq3+gttq4+gttq5+gttq6+gttq7+gttq8+gttq9
    end  
    
    def total_score
      (marks_a/45.0*25) + (marks_b/60.0*30) + (marks_c/20.0*5) + (marks_d/25.0*20) + (marks_e/45.0*20)
    end
    
    def grade
      return "A" if total_score >= 85 && total_score <=100
      return "B" if total_score >=70 && total_score <=84
      return "C" if total_score >=50 && total_score <=69
      return "D" if total_score >=40 && total_score <=49
      return "E" if total_score <40
    end
    
    def render_delivery
       (DropDown::DELIVERY_TYPE.find_all{|disp, value| value == delivery_type}).map{|disp, value| disp}.first
    end
    
end
