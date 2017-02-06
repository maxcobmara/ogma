class AverageInstructor < ActiveRecord::Base
  
  belongs_to :college
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
    
    def percent_a
      marks_a/45.0*25
    end
    
    def percent_b
      marks_b/60.0*30
    end
    
    def percent_c
      marks_c/20.0*5
    end
    
    def percent_d
      marks_d/25.0*20
    end
    
    def percent_e
      marks_e/45.0*20
    end
    
    def total_score
      percent_a+percent_b+percent_c+percent_d+percent_e
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
    
    def display_delivery
      if delivery_type==1
        a="T"
      elsif delivery_type==2
	a="P"
      elsif delivery_type==3
	a="L"
      end
      a
    end
    
    def display_objective
      str=[]
      if objective?
        str << objective.slice(0, 45)
        lines=objective.size/45
        1.upto(lines-1).each do |cnt|
	  str << objective.slice(cnt*45+1, 45)
        end
      end
      str
    end
    
    def duration
      durr=""
      jam=( (end_at-start_at) %60).to_i
      minit= (((end_at-start_at)/60)%60) .to_i
      if jam <= 0
	durr+="00"
      elsif jam < 10
	durr+="0"+jam.to_s
      elsif jam > 9
	durr+=jam.to_s
      end
      if minit <= 0
	durr+=":00"
      elsif minit< 10
	durr+=":0"+minit.to_s
      elsif minit > 9
	durr+=":"+minit.to_s
      end
    end
    
    def self.search2(search)
      if search
        where('instructor_id=? OR evaluator_id=?', search, search)
      end
    end
    
end
