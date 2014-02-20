class Bankaccount < ActiveRecord::Base
  belongs_to :staff
  belongs_to :bank
end

# == Schema Information
#
# Table name: bankaccounts
#
#  account_no   :string(255)
#  account_type :integer
#  bank_id      :integer
#  created_at   :datetime
#  id           :integer          not null, primary key
#  staff_id     :integer
#  student_id   :integer
#  updated_at   :datetime
#
