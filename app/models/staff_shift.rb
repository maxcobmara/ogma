class StaffShift < ActiveRecord::Base
  #has_and_belongs_to_many :staffs
  has_many :staffs
  has_many :shift_histories
  
  def start_end
    "#{start_at.strftime('%l:%M %p')} - #{end_at.strftime('%l:%M %p')}" 
  end
  
  def self.shift_id_in_use(curr_date, sa_thumbid)
    astaff=Staff.where('thumb_id=?',sa_thumbid).first
    if astaff
      abc=astaff.shift_histories.where('deactivate_date <?', curr_date) 
      if abc.count==0
        shift_id_use= astaff.staff_shift_id
      else
        shift_id_use= abc.last.shift_id
      end
    end
    shift_id_use
  end
  
  def self.shift_in_use(curr_date, sa_thumbid)
    astaff=Staff.where('thumb_id=?',sa_thumbid).first
    abc=astaff.shift_histories.where('deactivate_date <?', curr_date)
    if abc.count==0
      shift_use= astaff.staff_shift.start_end
    else
      shift_use= abc.last.staff_shift.start_end+"~"+(I18n.t 'staff_attendance.since')+" "+(abc.last.deactivate_date+1.day).strftime('%d-%m-%Y')
      #Notes: deactivate_date - last date for prev staff_shift
    end
    shift_use
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
