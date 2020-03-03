class TravelClaimReceipt < ActiveRecord::Base

  belongs_to :travel_claim
  
  def exchange_loss
    amount * 0.03
  end
  
  def exchange_loss_wrong
    exchanged = travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 99 ])
    number_with_precision((exchanged * 0.03), :precision => 2)
  end  
  
end

# == Schema Information
#
# Table name: travel_claim_receipts
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
#  travel_claim_id  :integer
#  updated_at       :datetime
#
