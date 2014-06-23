class TimetablePeriod < ActiveRecord::Base
  belongs_to :timetable
  
  DAY_CHOICE = [
       #  Displayed       stored in db
       [ "Sun-Wed",  1 ],
       [ "Thurs",    2 ]
  ]
  
  def timing
    "#{start_at.strftime("%l:%M %p")}"+" -"+"#{end_at.strftime("%l:%M %p")}"
  end 
  
  def duration 
    ("#{end_at.strftime('%l')}".to_i - "#{start_at.strftime('%l')}".to_i) * 60+ ("#{end_at.strftime('%M')}".to_i - "#{start_at.strftime('%M')}".to_i) 
  end
  
end
