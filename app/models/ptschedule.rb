class Ptschedule < ActiveRecord::Base

  belongs_to :course, :class_name => 'Ptcourse'
  validates_presence_of :ptcourse_id, :message => "Please Select Course"
  validates_presence_of :start, :location, :min_participants, :max_participants
  has_many :ptdos, :dependent => :destroy
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
