class Loan < ActiveRecord::Base
  belongs_to :staff
end

# == Schema Information
#
# Table name: loans
#
#  accno        :string(255)
#  amount       :decimal(, )
#  created_at   :datetime
#  deductions   :decimal(, )
#  durationmn   :integer
#  enddate      :date
#  enddeduction :decimal(, )
#  firstdate    :date
#  id           :integer          not null, primary key
#  ltype        :integer
#  staff_id     :integer
#  startdt      :date
#  updated_at   :datetime
#
