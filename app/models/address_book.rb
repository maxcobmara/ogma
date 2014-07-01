class AddressBook < ActiveRecord::Base
  
  has_many :provides, :class_name => 'Ptcourse', :foreign_key => 'provider_id'
  
end