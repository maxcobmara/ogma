class TimetablePeriod < ActiveRecord::Base
  belongs_to :timetable
  
  DAY_CHOICE = [
       #  Displayed       stored in db
       [ "Sun-Wed",  1 ],
       [ "Thurs",    2 ]
  ]
  
  def timing
    #"#{start_at.strftime("%l:%M %p")}"+" -"+"#{end_at.strftime("%l:%M %p")}"
    "#{start_at.try(:strftime, "%l:%M %P")}"+" - "+"#{end_at.try(:strftime, "%l:%M %P")}"
    #"%H:%m %P"
  end 
  
end
