class Ptschedule < ActiveRecord::Base

  has_many :ptdos, :dependent => :destroy
  belongs_to :course, :class_name => 'Ptcourse', foreign_key: 'ptcourse_id'
  
  validates_presence_of :ptcourse_id, :message => "Please Select Course"
  validates_presence_of :start, :location, :min_participants, :max_participants
  
  validates :max_participants, :numericality => { :less_than_or_equal_to => 999 }
  validates :min_participants, :numericality => { :greater_than => 0, :less_than_or_equal_to => :max_participants }, :unless => 'max_participants.nil?'
  
  def enddate
    duration=Ptdo.staff_course_days(Ptcourse.find(ptcourse_id))
    bal_hours = duration % 6
    days_count = duration / 6
    if bal_hours >= 3                 #6 hours=1 day
      duration=days_count+1
    end
    start+duration.to_i.day
  end
  
end

# == Schema Information
#
# Table name: ptschedules
#
#  budget_ok        :boolean
#  created_at       :datetime
#  final_price      :decimal(, )
#  id               :integer          not null, primary key
#  location         :string(255)
#  max_participants :integer
#  min_participants :integer
#  ptcourse_id      :integer
#  start            :date
#  updated_at       :datetime
#
