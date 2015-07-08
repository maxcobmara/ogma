class Timetable < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  before_destroy :valid_for_removal
  belongs_to :creator, :class_name => 'Staff', :foreign_key => 'created_by'
  
  has_many :timetable_periods, :dependent => :destroy
  accepts_nested_attributes_for :timetable_periods, :allow_destroy => true#, :reject_if => lambda { |a| a[:start_at].blank? }

  #20March2013- weeklytimetables - newly added models..
  has_many :timetable_for_monthurs,   :class_name => 'WeeklyTimetable'#, :foreign_key => 'format1'#, :dependent => :nullify
  has_many :timetable_for_friday,     :class_name => 'WeeklyTimetable'#, :foreign_key => 'format2'#, :dependent => :nullify

  def timetable_in_use
    wts=Weeklytimetable.all.pluck(:format1, :format2)
    timetable_use=Array.new
    wts.each{|x|timetable_use +=x}
    timetable_use.uniq
  end
  
  #as long as in use, timetable is INVALID for removal, as well as its timetable_periods(no slot can be removed)
  def valid_for_removal
    if timetable_in_use.include?(id)
      return false
    else
      return true
    end
  end
  
  #WT published (submitted & approved)
  def timetable_activated 
    wts=Weeklytimetable.where('is_submitted is true and hod_approved is true').pluck(:format1, :format2)
    activated=Array.new
    wts.each{|x|activated +=x}
    if activated.uniq.include?(id)
      return true
    else
      return false
    end
  end
  
end

# == Schema Information
#
# Table name: timetables
#
#  code        :string(255)
#  created_at  :datetime
#  created_by  :integer
#  description :string(255)
#  id          :integer          not null, primary key
#  name        :string(255)
#  updated_at  :datetime
#
