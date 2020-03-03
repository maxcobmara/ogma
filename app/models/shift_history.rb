class ShiftHistory < ActiveRecord::Base
  belongs_to :staff, :foreign_key => 'staff_id'
  belongs_to :staff_shift, :foreign_key => 'shift_id' 
end

# == Schema Information
#
# Table name: shift_histories
#
#  created_at      :datetime
#  deactivate_date :date
#  id              :integer          not null, primary key
#  shift_id        :integer
#  staff_id        :integer
#  updated_at      :datetime
#
