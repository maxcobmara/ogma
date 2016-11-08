class WeeklytimetableDetail < ActiveRecord::Base
   
   before_save :set_day_time_slot_for_non_selected
   #before_save :set_false_if_topic_not_exist 

   before_destroy :check_student_attendance, :check_lesson_plan
   
   belongs_to :weeklytimetable,     :foreign_key => 'weeklytimetable_id'
   belongs_to :weeklytimetable_subject,   :class_name => 'Programme',   :foreign_key => 'subject' #starting 25March2013-no longer use
   belongs_to :weeklytimetable_topic,     :class_name => 'Programme',   :foreign_key => 'topic'
   belongs_to :weeklytimetable_lecturer,  :class_name => 'Staff',       :foreign_key => 'lecturer_id'
   belongs_to :weeklytimetable_location,  :class_name => 'Location',    :foreign_key => 'location'
   #has_one    :lessonplan,                :class_name => 'LessonPlan',  :foreign_key => 'schedule', :dependent => :nullify #31OCT2013 - :dependent => :destroy #####to UNREMARK when student attendance is ready******  26JUNE2014
   has_many   :student_attendances
   
   belongs_to :fridayslot,      :class_name => 'TimetablePeriod', :foreign_key => 'time_slot'  ##sequence save not ID of TimetablePeriod
   belongs_to :monthurslot, :class_name => 'TimetablePeriod', :foreign_key => 'time_slot2'  ##sequence save not ID of TimetablePeriod
   
   #validates_presence_of :lecturer_id, :lecture_method, :if => :topic?#,:time_slot, :time_slot2, :day2, :is_friday, :location,
   validates_presence_of :weeklytimetable_id
   
   serialize :data, Hash
   
   def set_day_time_slot_for_non_selected
       if is_friday == true
         self.day2 = 0
         self.time_slot2 = 0
       elsif is_friday != true 
         self.is_friday = false
         self.time_slot = 0
       end 
   end

   def klass_name=(value)
     data[:klass_name]=value
   end
  
   def klass_name
     data[:klass_name]
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
     return (sdate+5).strftime('%d-%b-%Y') if day2 == 6
     return (sdate+6).strftime('%d-%b-%Y') if day2 == 7
   end   
   
   def get_date_day_of_schedule
      sdate = Weeklytimetable.find(weeklytimetable_id).startdate
      endate = Weeklytimetable.find(weeklytimetable_id).enddate
      return (sdate).strftime('%d-%b-%Y') + " Mon" if day2 == 1
      return (sdate+1).strftime('%d-%b-%Y') + " Tue" if day2 == 2
      return (sdate+2).strftime('%d-%b-%Y') + " Wed" if day2 == 3
      return (sdate+3).strftime('%d-%b-%Y') + " Thu" if day2 == 4
      return (endate).strftime('%d-%b-%Y') + " Fri" if is_friday == true  
      return (sdate+5).strftime('%d-%b-%Y') + " Sat" if day2 == 6
      return (sdate+6).strftime('%d-%b-%Y') + " Sun" if day2 == 7
   end   
   
   #usage - lesson_plan.rb -  to save default value of start_time, which later being used in Index & Show
   def get_start_time
#      timeslot = time_slot2 if is_friday == false || is_friday == nil
#      timeslot = time_slot if is_friday == true 
#      "#{weeklytimetable.timetable_monthurs.timetable_periods.where(sequence: timeslot).first.start_at.strftime("%l:%M %p")}"
     if is_friday == false || is_friday == nil
       "#{weeklytimetable.timetable_monthurs.timetable_periods.where(sequence: time_slot2).first.start_at.strftime("%l:%M %p")}"
     else
       "#{weeklytimetable.timetable_friday.timetable_periods.where(sequence: time_slot).first.start_at.strftime("%l:%M %p")}"
     end
   end   
   
   #usage - lesson_plan.rb -  to save default value of end_time, which later being used in Index & Show
   def get_end_time
#      timeslot = time_slot2 if is_friday == false || is_friday == nil
#      timeslot = time_slot if is_friday == true 
#      "#{weeklytimetable.timetable_friday.timetable_periods.where(sequence: timeslot).first.end_at.strftime("%l:%M %p")}"
     if is_friday == false || is_friday == nil
       "#{weeklytimetable.timetable_monthurs.timetable_periods.where(sequence: time_slot2).first.end_at.strftime("%l:%M %p")}"
     else
       "#{weeklytimetable.timetable_friday.timetable_periods.where(sequence: time_slot).first.end_at.strftime("%l:%M %p")}"
     end
   end   
   
   #working sample: Student Attendance - Index pg - 17Oct2016
   def get_time_slot
      #asal
      #timeslot = time_slot2 if is_friday == false || is_friday == nil
      #timeslot = time_slot if is_friday == true 
      #stime = "#{TimetablePeriod.find(timeslot).start_at.strftime("%l:%M %p")}"+"-"+"#{TimetablePeriod.find(timeslot).end_at.strftime("%l:%M %p")}"
      ####
      if is_friday == false || is_friday == nil
        timeslot = time_slot2 
        slot=weeklytimetable.timetable_monthurs.timetable_periods.where(sequence: timeslot).first   #format1
      end
      if is_friday == true 
        timeslot = time_slot 
        slot=weeklytimetable.timetable_friday.timetable_periods.where(sequence: timeslot).first         #weeklytimetable.format2
      end
      if weeklytimetable.college.code=='amsas'
        stime="#{slot.start_at.strftime('%H:%M')} - #{slot.end_at.strftime('%H:%M')}"
      else
        stime="#{slot.start_at.strftime("%l:%M %p")} - #{slot.end_at.strftime("%l:%M %p")}"
      end
   end
   
   def day_time_slot
      "#{get_date_day_of_schedule}"+" | "+"#{get_time_slot}"+" | "+"#{Programme.find(topic).subject_with_topic}"
   end
   
   def day_time_slot2
      "#{get_date_day_of_schedule}"+" | "+"#{get_time_slot}"
   end
   
   def day_time_slot3
     wl=weeklytimetable_lecturer
     if wl.rank_id?
       "#{wl.rank.shortname} #{wl.name[0,20]}"+" | "+"#{day_time_slot}"
     else
       "#{wl.name[0,10]}"+" | "+"#{day_time_slot}"
     end
   end
   
   def subject_day_time
      "#{Programme.find(topic).parent.code}"+" | "+"#{get_date_day_of_schedule}"+" | "+"#{get_time_slot}"
   end
   
   def subject_topic
     #{}"#{Programme.find(topic).subject_with_topic}"
     "#{Programme.find(topic).parent.code}"+" : "+"#{Programme.find(topic).subject_list}"
   end
   
   def render_class_method
     (DropDown::CLASS_METHOD.find_all{|disp, value| value == lecture_method}).map {|disp, value| disp}
   end
   
   def subject_day_time_class_method
      "#{subject_day_time}"+ " ("+"#{render_class_method}"+")"
   end
   
   def subject_details
      [subject_day_time, id]
   end
     
     #25March2013==========
  private
     
     def check_student_attendance
       student_attendance_exist = StudentAttendance.where('weeklytimetable_details_id=?',id)
       if student_attendance_exist.count>0
         return false
       end
     end
     
     #this part will only restrict user from REMOVING current daily timetable detail (TIME SLOT)
     #but pls note replacing content(topic, location etc) of current daily timetable detail (TIME SLOT) shall REFLECT schedule details(topic, timing, etc) in Lesson Plan
     def check_lesson_plan
       current_schedule = 
       submitted_lesson_plan = LessonPlan.where('is_submitted=?', true).pluck(:schedule)
       if submitted_lesson_plan.include?(self.id)
         #lesson plan created, schedule editable? #issue arise during training : lesson plan first created by lecturer, schedule used to be last minute produce by Coordinator
         #errors.add_to_base "tak bole la"
         # raise I18n.t("weeklytimetable_detail.removal_not_allowed")
         return false
       end
     end
     
end

# == Schema Information
#
# Table name: weeklytimetable_details
#
#  created_at         :datetime
#  day2               :integer
#  id                 :integer          not null, primary key
#  is_friday          :boolean
#  lecture_method     :integer
#  lecturer_id        :integer
#  location           :integer
#  subject            :integer
#  time_slot          :integer
#  time_slot2         :integer
#  topic              :integer
#  updated_at         :datetime
#  weeklytimetable_id :integer
#

