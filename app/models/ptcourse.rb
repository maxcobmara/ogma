class Ptcourse < ActiveRecord::Base
  
  has_many :scheduled, :class_name => 'Ptschedule'
  belongs_to :provider, :class_name => 'AddressBook', :foreign_key => 'provider_id'
  
  validates_presence_of :name
  
  def rendered_programme_classification
    (DropDown::PROGRAMME_CLASSIFICATION.find_all{|disp, value| value == training_classification}).map {|disp, value| disp}.first
  end
  
  def rendered_course_type
    (DropDown::COURSE_TYPE.find_all{|disp, value| value == course_type }).map {|disp, value| disp}.first
  end
  
  def rendered_course_duration
    (DropDown::DURATION_TYPE.find_all{|disp, value| value == duration_type }).map {|disp, value| disp}[0]
  end
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
