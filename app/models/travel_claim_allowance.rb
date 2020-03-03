class TravelClaimAllowance < ActiveRecord::Base
  
  before_save :make_total
  
  belongs_to :travel_claim
  
  def make_total
    self.total = quantity * amount
  end
  
  def allow_expend_type
    spend = (DropDown::ALLOWANCETYPE.find_all{|disp, value| value == expenditure_type}).map {|disp, value| disp}[0]
    spend.to_s.titleize
  end
  
end

# == Schema Information
#
# Table name: travel_claim_allowances
#
#  amount           :decimal(, )
#  checker          :boolean
#  checker_notes    :string(255)
#  created_at       :datetime
#  expenditure_type :integer
#  id               :integer          not null, primary key
#  quantity         :decimal(, )
#  receipt_code     :string(255)
#  spent_on         :date
#  total            :decimal(, )
#  travel_claim_id  :integer
#  updated_at       :datetime
#
