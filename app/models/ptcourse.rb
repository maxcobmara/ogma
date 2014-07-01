class Ptcourse < ActiveRecord::Base
  
  belongs_to :provider, :class_name => 'AddressBook', :foreign_key => 'provider_id'
  
  validates_presence_of :name
end