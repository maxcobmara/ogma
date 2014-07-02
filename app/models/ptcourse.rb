class Ptcourse < ActiveRecord::Base
  
  
  has_many :scheduled, :class_name => 'Ptschedule'
  belongs_to :provider, :class_name => 'AddressBook', :foreign_key => 'provider_id'
  
  validates_presence_of :name
end

# == Schema Information
#
# Table name: ptcourses
#
#  approved      :boolean
#  cost          :decimal(, )
#  course_type   :integer
#  created_at    :datetime
#  description   :text
#  duration      :decimal(, )
#  duration_type :integer
#  id            :integer          not null, primary key
#  name          :string(255)
#  proponent     :string(255)
#  provider_id   :integer
#  updated_at    :datetime
#
