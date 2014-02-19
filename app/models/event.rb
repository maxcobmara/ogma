class Event < ActiveRecord::Base
  
  before_save  :titleize_eventname
  
  belongs_to :staff, :foreign_key => 'createdby'
  
  validates_presence_of :eventname, :location, :start_at

  def titleize_eventname
    self.eventname = eventname.titleize
  end
    
end
