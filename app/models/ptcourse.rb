class Ptcourse < ActiveRecord::Base
  
  
  has_many :scheduled, :class_name => 'Ptschedule'
  belongs_to :provider, :class_name => 'AddressBook', :foreign_key => 'provider_id'
  
  validates_presence_of :name
end