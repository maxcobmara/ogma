class Lessonplansearch < ActiveRecord::Base
  attr_accessor :intake_programme
  
  before_save :update_intake
  
  belongs_to :college
  
  def lessonplans
    @lessonplans ||= find_lessonplans
  end
  
  def validintake_data  #get valid WtimetableDetail_ids
    WeeklytimetableDetail.where(weeklytimetable_id: Weeklytimetable.validintake_timetable).pluck(:id)
  end
  
  def update_intake
    unless intake_programme.blank?
      siri=intake_programme.split(" |")[0].gsub("Siri ", "")
      intakeid=Intake.where("name ILIKE(?)", "%#{siri}%").first.id
      self.intake_id=intakeid
    end
  end
  
  private

   def find_lessonplans
     LessonPlan.where(conditions).order(orders)   
   end
   
   def subject_conditions
     if college.code=='amsas'
       unless subject.blank?
         wtd_ids=WeeklytimetableDetail.where(subject: subject).pluck(:id)
         a=" schedule=? " if wtd_ids.count > 0
         0.upto(wtd_ids.count-2).each do |cnt|
           a+=" OR schedule=? "
         end
       end
       ["("+a+")", wtd_ids] unless subject.blank?
     else
       unless subject.blank?
         topics_ids_prog=Programme.find(subject).descendants.map(&:id) 
         a=" topic=? " if topics_ids_prog.count > 0
         0.upto(topics_ids_prog.count-2).each do |cnt|
           a+=" OR topic=? "
         end
       end
       ["("+a+")", topics_ids_prog] unless subject.blank?
     end
   end
   
   def loggedin_staff_details
     if loggedin_staff==0         
       all_lecturers = LessonPlan.all.map(&:lecturer)
       a=" lecturer=? " if all_lecturers.count > 0
       0.upto(all_lecturers.count-2).each do |cnt|
         a+=" OR lecturer=? "
       end
       b=["("+a+")", all_lecturers] 
     else
       if loggedin_staff.to_s.size > 3
         comb_staff = loggedin_staff.to_s
         progid=(comb_staff[3, comb_staff.size]).to_i
         all_intakes = LessonPlan.all.map(&:intake_id)
         intakes_of_prog = Intake.where('id IN(?) and programme_id=?',all_intakes, progid).map(&:id)
         a=" intake_id=? " if intakes_of_prog.count > 0
         0.upto(intakes_of_prog.count-2).each do |cnt|
           a+=" OR intake_id=? "
         end
         b=["("+a+")", intakes_of_prog]
       else
         b=["lecturer=?", loggedin_staff]
       end
     end
     return b unless loggedin_staff.blank?
   end
   
   def loggedin_staff_conditions
     loggedin_staff_details unless loggedin_staff.blank?
   end
   
#    def valid_schedule_conditions
#      valid_schedule_ids = WeeklytimetableDetail.valid_sch_ids
#      if valid_schedule_ids.count > 0
#        a=" schedule=? " if valid_schedule_ids.count > 0
#        0.upto(valid_schedule_ids.count-2).each do |cnt|
#          a+=" OR schedule=? "
#        end
#        ["("+a+")", valid_schedule_ids] if valid_schedule == 1
#      end
#    end 
   
   #schedule refer 2 classes - WeeklytimetableDetails
   def valid_schedule_conditions
     a="schedule=?" if validintake_data.count > 0
     0.upto(validintake_data.count-2) do |cnt|
       a+=" OR schedule=? "  if validintake_data.count > 1
     end
       ["("+a+")", validintake_data] if valid_schedule==1 || valid_schedule=='1'
   end

   def intake_id_conditions
     ["intake_id=?", intake_id] if !intake_id.blank? && intake != '0'            #if intake != 0 ##unless intake_id.blank? && intake != 1   #intake_id exist & intake must 1  
   end

   def lecturer_conditions
     ["lecturer=?", lecturer] unless lecturer.blank?      
   end
  
  def orders
    #"intake_id ASC"
  end  

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
  
  
end