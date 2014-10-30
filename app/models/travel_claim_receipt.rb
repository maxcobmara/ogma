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
