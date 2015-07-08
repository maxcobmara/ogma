class TimetablePeriod < ActiveRecord::Base
  belongs_to :timetable, :foreign_key => 'timetable_id'
  
  validates_presence_of :timetable_id
  validates_uniqueness_of :sequence, :scope => :timetable_id
  
  def timing
    #"#{start_at.strftime("%l:%M %p")}"+" -"+"#{end_at.strftime("%l:%M %p")}"
    "#{start_at.try(:strftime, "%l:%M%P")}"+"-"+"#{end_at.try(:strftime, "%l:%M%P")}"
    #"%H:%m %P"
  end 
  
end

# == Schema Information
#
# Table name: timetable_periods
#
#  created_at   :datetime
#  day_name     :integer
#  end_at       :time
#  id           :integer          not null, primary key
#  is_break     :boolean
#  sequence     :integer
#  start_at     :time
#  timetable_id :integer
#  updated_at   :datetime
#
