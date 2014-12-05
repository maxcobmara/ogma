class StaffShift < ActiveRecord::Base
  #has_and_belongs_to_many :staffs
  has_many :staffs
  has_many :shift_histories
  
  def start_end
    "#{start_at.strftime('%l:%M %p')} - #{end_at.strftime('%l:%M %p')}" 
  end
end

# == Schema Information
#
# Table name: staff_shifts
#
#  created_at :datetime
#  end_at     :time
#  id         :integer          not null, primary key
#  name       :string(255)
#  start_at   :time
#  updated_at :datetime
#
