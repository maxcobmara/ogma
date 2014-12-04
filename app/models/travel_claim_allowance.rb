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
