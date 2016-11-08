class LessonplanMethodology < ActiveRecord::Base
  belongs_to :lesson_plan,     :foreign_key => 'lesson_plan_id'
  belongs_to :college
  
   def start_end_time
    if college.code=='amsas'
      "#{start_meth.strftime('%H:%M') }"+" - "+"#{end_meth.strftime('%H:%M') }"
    else
      "#{start_meth.strftime('%l:%M') }"+" - "+"#{end_meth.strftime('%l:%M %p') }"
    end
  end
  
  def start_end_time_in_minutes
    endtime=end_meth.to_time
    starttime=start_meth.to_time
    diff=endtime-starttime
    "(#{ diff / 60}"+" minutes)"
    #"("+"#{ (((l.end_meth - l.start_meth )/60 ) % 60).to_i }"+" minutes)"
  end
  
end
