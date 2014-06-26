class WeeklytimetableDetail < ActiveRecord::Base
   
   before_save :set_day_time_slot_for_non_selected
   #before_save :set_false_if_topic_not_exist 

   #before_destroy :check_student_attendance  #####to UNREMARK when student attendance is ready****************************   26JUNE2014
   
   belongs_to :weeklytimetable,     :foreign_key => 'weeklytimetable_id'
   belongs_to :weeklytimetable_subject,   :class_name => 'Programme',   :foreign_key => 'subject' #starting 25March2013-no longer use
   belongs_to :weeklytimetable_topic,     :class_name => 'Programme',   :foreign_key => 'topic'
   belongs_to :weeklytimetable_lecturer,  :class_name => 'Staff',       :foreign_key => 'lecturer_id'
   belongs_to :weeklytimetable_location,  :class_name => 'Location',    :foreign_key => 'location'
   #has_one    :lessonplan,                :class_name => 'LessonPlan',  :foreign_key => 'schedule', :dependent => :nullify #31OCT2013 - :dependent => :destroy #####to UNREMARK when student attendance is ready******  26JUNE2014
   has_many   :student_attendances
      
   #validates_uniqueness_of :lecturer_id, :time_slot, :time_slot2, :day2, :is_friday, :scope => :weeklytimetable_id
   validates_presence_of :lecturer_id, :lecture_method, :if => :topic?#,:time_slot, :time_slot2, :day2, :is_friday, :location,
   
   def set_day_time_slot_for_non_selected
       if is_friday == true
         self.day2 = 0
         self.time_slot2 = 0
       elsif is_friday != true 
         self.is_friday = false
         self.time_slot = 0
       end 
   end
   
   #def set_false_if_topic_not_exist
     #if self.topic.blank?
       #return false
       #end
   #end
   
   def get_date_for_lesson_plan
     sdate = Weeklytimetable.find(weeklytimetable_id).startdate
     endate = Weeklytimetable.find(weeklytimetable_id).enddate
     return (sdate).strftime('%d-%b-%Y') if day2 == 1
     return (sdate+1).strftime('%d-%b-%Y') if day2 == 2
     return (sdate+2).strftime('%d-%b-%Y') if day2 == 3
     return (sdate+3).strftime('%d-%b-%Y') if day2 == 4
     return (endate).strftime('%d-%b-%Y') if is_friday == true
   end   
   
   def get_date_day_of_schedule
      sdate = Weeklytimetable.find(weeklytimetable_id).startdate
      endate = Weeklytimetable.find(weeklytimetable_id).enddate
      return (sdate).strftime('%d-%b-%Y') + " Mon" if day2 == 1
      return (sdate+1).strftime('%d-%b-%Y') + " Tue" if day2 == 2
      return (sdate+2).strftime('%d-%b-%Y') + " Wed" if day2 == 3
      return (sdate+3).strftime('%d-%b-%Y') + " Thu" if day2 == 4
      return (endate).strftime('%d-%b-%Y') + " Fri" if is_friday == true  
   end   
   
   def get_start_time
     timeslot = time_slot2 if is_friday == false || is_friday == nil
     timeslot = time_slot if is_friday == true 
     "#{TimetablePeriod.find(timeslot).start_at.strftime("%H:%M %p")}"
   end   
   
   def get_end_time
     timeslot = time_slot2 if is_friday == false || is_friday == nil
     timeslot = time_slot if is_friday == true 
     "#{TimetablePeriod.find(timeslot).end_at.strftime("%H:%M %p")}"
   end   
   
   def get_time_slot
      timeslot = time_slot2 if is_friday == false || is_friday == nil
      timeslot = time_slot if is_friday == true 
      stime = "#{TimetablePeriod.find(timeslot).start_at.strftime("%H:%M %p")}"+"-"+"#{TimetablePeriod.find(timeslot).end_at.strftime("%H:%M %p")}"
   end
   
   def day_time_slot
      "#{get_date_day_of_schedule}"+" | "+"#{get_time_slot}"+" | "+"#{Programme.find(topic).subject_with_topic}"
   end
   
   def day_time_slot2
      "#{get_date_day_of_schedule}"+" | "+"#{get_time_slot}"
   end
   
   def subject_day_time
      "#{Programme.find(topic).parent.code}"+" | "+"#{get_date_day_of_schedule}"+" | "+"#{get_time_slot}"
   end
   
   def subject_topic
     #{}"#{Programme.find(topic).subject_with_topic}"
     "#{Programme.find(topic).parent.code}"+" : "+"#{Programme.find(topic).subject_list}"
   end
   
   def render_class_method
     (WeeklytimetableDetail::CLASS_METHOD.find_all{|disp, value| value == lecture_method}).map {|disp, value| disp}
   end
   
   def subject_day_time_class_method
      "#{subject_day_time}"+ " ("+"#{render_class_method}"+")"
   end

   DAY_LIST = [
           #  Displayed       stored in db
           ["Monday",     1],
           ["Tuesday",    2],
           ["Wednesday",  3],
           ["Thursday",   4]
     ]
    CLASS_METHOD = [
           #  Displayed       stored in db
           ["Kuliah",     1],
           ["Teori",    2],
           ["Amali",  3]
     ]
     
     #25March2013==========
  private
     
     def check_student_attendance
       student_attendance_exist = StudentAttendance.find(:all, :conditions=>['weeklytimetable_details_id=?',id])
       if student_attendance_exist.count>0
         return false
       end
     end

end