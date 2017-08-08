class Personalizetimetablesearch < ActiveRecord::Base
  
   def personalizetimetables
     @personalizetimetables ||= find_personalizetimetables
   end

   private

   def find_personalizetimetables
     WeeklytimetableDetail.where(conditions).order(orders)
   end
   
   def programme_id_conditions
     valid_wt_ids = Weeklytimetable.validintake_timetable  #Weeklytimetable.valid_wt_ids
     if valid_wt_ids.count > 0
       a=" weeklytimetable_id=? " if valid_wt_ids.count > 0
       0.upto(valid_wt_ids.count-2).each do |cnt|
         a+=" OR weeklytimetable_id=? "
       end
       ["("+a+")", valid_wt_ids] if programme_id == 1
     end
   end

   def lecturer_conditions
     ["lecturer_id=?", lecturer] unless lecturer.blank?      
   end
   
   def startdate_conditions
     unless startdate.blank? 
       searched_slots=WeeklytimetableDetail.joins(:weeklytimetable).where('weeklytimetables.startdate >=?', startdate).map(&:id).uniq
       if searched_slots.count > 0
         a="id=? "
         0.upto(searched_slots.count-2) do |cnt|
           a+=" OR id=? " if searched_slots.count > 1
         end
	 ["("+a+")", searched_slots]
       else
         ["id=?", nil]
       end
     end
   end
   
   def enddate_conditions
     unless enddate.blank? 
       searched_slots=WeeklytimetableDetail.joins(:weeklytimetable).where('weeklytimetables.startdate <=?', enddate).map(&:id).uniq
       if searched_slots.count > 0
         a="id=? "
         0.upto(searched_slots.count-2) do |cnt|
           a+=" OR id=? " if searched_slots.count > 1
         end
	 ["("+a+")", searched_slots]
       else
         ["id=?", nil]
       end
     end
   end
   
   def orders
     "lecturer_id ASC, id ASC"
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