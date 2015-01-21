class Event < ActiveRecord::Base

  paginates_per 15 
  before_save  :titleize_eventname

  belongs_to :staff, :foreign_key => 'createdby'

  validates_presence_of :eventname, :start_at, :end_at, :location, :participants, :officiated, :createdby

  def titleize_eventname
    self.eventname = eventname.titleize
  end

end

# == Schema Information
#
# Table name: events
#
#  created_at      :datetime
#  createdby       :integer
#  end_at          :datetime
#  event_is_publik :boolean
#  eventname       :string(255)
#  id              :integer          not null, primary key
#  location        :string(255)
#  officiated      :string(255)
#  participants    :text
#  start_at        :datetime
#  updated_at      :datetime
#
