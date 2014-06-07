class AssetLoan < ActiveRecord::Base
   
   belongs_to :asset
end

# == Schema Information
#
# Table name: asset_loans
#
#  approved_date    :date
#  asset_id         :integer
#  created_at       :datetime
#  expected_on      :date
#  hod              :integer
#  hod_date         :date
#  id               :integer          not null, primary key
#  is_approved      :boolean
#  is_returned      :boolean
#  loan_officer     :integer
#  loaned_by        :integer
#  loaned_on        :date
#  loantype         :integer
#  reasons          :text
#  received_officer :integer
#  remarks          :text
#  returned_on      :date
#  staff_id         :integer
#  updated_at       :datetime
#
