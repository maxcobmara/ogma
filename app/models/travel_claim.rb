class TravelClaim < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  before_save :set_to_nil_where_false, :set_total
  
  belongs_to :staff
  belongs_to :approver,           :class_name => 'Staff',      :foreign_key => 'approved_by'
  
  has_many :travel_requests
  accepts_nested_attributes_for :travel_requests
  
  has_many :travel_claim_receipts, :dependent => :destroy
  accepts_nested_attributes_for :travel_claim_receipts, :reject_if => lambda { |a| a[:amount].blank? }, :allow_destroy =>true
  
  #has_many :travel_claim_logs, :through => :travel_requests
  
  has_many :travel_claim_allowances, :dependent => :destroy
  accepts_nested_attributes_for :travel_claim_allowances, :reject_if => lambda { |a| a[:amount].blank? }, :allow_destroy =>true
  
  validates_uniqueness_of :claim_month, :scope => :staff_id, :message => "You already have claims for this month"
  
  def set_to_nil_where_false
    if is_submitted == true
      self.submitted_on= Date.today
      #finance check
      if is_returned == true
        self.is_checked == false
      end
      #check part?
      if is_checked == false && staff_id != Login.current_login.staff_id  #2nd time return by finance
        self.is_returned = true
      end
      if is_checked == true
        self.checked_on = Date.today
        #self.checked_by =  Login.current_login.staff_id  #current_user???
      end
    else
      self.submitted_on= nil
    end
  end
  
  def set_total
    self.total = total_claims
  end
  
  def my_claim_status(current_user)
    if staff_id == current_user.userable.id && is_submitted != true 
      "editing"
    elsif staff_id != current_user.userable.id && is_submitted != true	#add-in to make sure it work with - those HACK part in index page - to differentiate with "editing" & login as finance staff
     "editing by staff"
    elsif staff_id == current_user.userable.id && is_submitted == true && is_checked == nil
      "submitted"
    elsif staff_id != current_user.userable.id && is_submitted == true && is_checked == nil
      "for checking"
    elsif staff_id == current_user.userable.id && is_submitted == true && is_checked == false && is_returned == true
      "returned"
    elsif staff_id == current_user.userable.id && is_submitted == true && is_checked == false && is_returned == false 
      "resubmitted to finance"
    elsif staff_id != current_user.userable.id && is_submitted == true && is_checked == false	&& is_returned == false 
      "for checking"
    elsif is_submitted == true && is_checked == true && is_approved != true
      "processed"
    elsif is_submitted == true && is_checked == true && is_approved == true
      "approved"
    elsif staff_id != current_user.userable.id && is_submitted == true && is_checked ==false && is_returned == true 
      "return to staff for amendment"
    else
      "status not known"
    end    
  end
  
  
  
  
  def to_be_paid
    if advance == nil
      total_claims
    else
      total_claims - advance
    end
  end
  
  def total_claims 
     receipts + allowas + value_km
  end
   
  def receipts
    other_claims_total + public_transport_totals #public_transport_totals=all public transport receipts+total_km_money
  end
  
  def allowas
    travel_claim_allowances.sum(:total)
  end
  
  
  
  
  #items for claimprint
  
  def km500
    if total_mileage == nil 
      0.0 
    elsif total_mileage != nil && total_mileage < 501
      total_mileage
    else
      500
    end
  end
  
  def km1000
    if total_mileage == nil || total_mileage < 501
      0.0
    elsif total_mileage < 1001
      total_mileage - 500
    else
      500
    end
  end
  
  def km1700
    if total_mileage == nil || total_mileage < 1001
      0.0
    elsif total_mileage < 1701
      total_mileage - 1000
    else
      700
    end
  end
  
  def kmmo
    if total_mileage == nil || total_mileage < 1701
      0.0
    else
      total_mileage - 1700
    end
  end
  
  def transport_class
    abc = TravelClaimsTransportGroup.abcrate
    de = TravelClaimsTransportGroup.derate
    mid = 1820.75
    if staff.vehicles && staff.vehicles.count>0
      TravelClaimsTransportGroup.transport_class(staff.vehicles.first.id, staff.current_salary, abc, de, mid)
    else
       'Z'
    end
  end
  
  def sen_per_km500  #hack into a db
    if transport_class == 'Z'
      0
    else
      TravelClaimMileageRate.km_by_group(500, transport_class)*100
    end
  end
  
  def sen_per_km1000
    if transport_class == 'Z'
      0
    else
      TravelClaimMileageRate.km_by_group(1000, transport_class)*100
    end
  end

  def sen_per_km1700
    if transport_class == 'Z'
      0
    else
      TravelClaimMileageRate.km_by_group(1700, transport_class)*100
    end
  end
  
  def sen_per_kmmo
    if transport_class == 'Z'
      0
    else
      TravelClaimMileageRate.km_by_group(99999, transport_class)*100
    end
  end
  
  def value_km500
    if total_mileage != nil
     (km500 * sen_per_km500)/100
    end
  end
  
  def value_km1000
    if total_mileage != nil
      (km1000 * sen_per_km1000)/100
    end
  end
  
  def value_km1700
    if total_mileage != nil
      (km1700 * sen_per_km1700)/100
    end
  end
  
  def value_kmmo
    if total_mileage != nil
      (kmmo * sen_per_kmmo)/100
    end
  end
  
  def value_km
    if total_mileage != nil
      value_km500 + value_km1000 + value_km1700 + value_kmmo
    end
  end
  
  
  
  #allowances
  
  def allowance_totals
    #travel_claim_allowances.sum(:total, :conditions => ["expenditure_type IN (?)", [21,22,23] ])
    travel_claim_allowances.where("expenditure_type IN (?)", [21,22,23] ).sum(:total)
  end
  
  def hotel_totals
    #travel_claim_allowances.sum(:total, :conditions => ["expenditure_type IN (?)", [31,32,33] ])
    travel_claim_allowances.where("expenditure_type IN (?)", [31,32,33] ).sum(:total)
  end
  
  
  
  #public transport
  def taxi_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 11]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 11).map(&:receipt_code).join(", ")
  end
  def taxi_receipts_total
    #(travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 11])) + total_km_money
    (travel_claim_receipts.where(expenditure_type: 11).sum(:amount)) + total_km_money     #taxi (receipts) + taxi (in log details)
  end
  
  def bus_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 12]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 12).map(&:receipt_code).join(", ")
  end
  def bus_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 12])
    travel_claim_receipts.where(expenditure_type: 12).sum(:amount)
  end
  
  def train_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 13]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 13).map(&:receipt_code).join(", ")
  end
  def train_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 13])
    travel_claim_receipts.where(expenditure_type: 13).sum(:amount)
  end
  
  def ferry_receipts
   # travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 14]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 14).map(&:receipt_code).join(", ")
  end
  def ferry_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 14])
    travel_claim_receipts.where(expenditure_type:14) .sum(:amount)
  end
  
  def plane_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 15]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 15).map(&:receipt_code).join(", ")
  end
  def plane_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 15])
    travel_claim_receipts.where(expenditure_type: 15).sum(:amount)
  end
  
  def public_transport_totals
   # (travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type IN (?)", [11,12,13,14,15] ])) + total_km_money
    (travel_claim_receipts.where("expenditure_type IN (?)", [11,12,13,14,15]).sum(:amount)) + total_km_money
  end
  
  def exchange_loss_totals
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 99 ]) * 0.03
    travel_claim_receipts.where(expenditure_type: 99).sum(:amount) * 0.03
  end
  

  
  
  #Other 
  def toll_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 41]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 41).map(&:receipt_code).join(", ")
  end
  def toll_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 41])
    travel_claim_receipts.where(expenditure_type: 41).sum(:amount)
  end
  
  def parking_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 42]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 42).map(&:receipt_code).join(", ")
  end
  def parking_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 42])
    travel_claim_receipts.where(expenditure_type = ?", 42)
  end
  
  def laundry_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 43]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 43).map(&:receipt_code).join(", ")
  end
  def laundry_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 43])
    travel_claim_receipts.where(expenditure_type: 43).sum(:amount)
  end
  
  def pos_receipts
    #travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 44]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 44).map(&:receipt_code).join(", ")
  end
  def pos_receipts_total
   # travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 44])
    travel_claim_receipts.where(expenditure_type: 44).sum(:amount)
  end
  
  def comms_receipts
   # travel_claim_receipts.find(:all, :select => 'receipt_code', :conditions => ["expenditure_type = ?", 45]).map(&:receipt_code).join(", ")
    travel_claim_receipts.where(expenditure_type: 45).map(&:receipt_code).join(", ")
  end
  def comms_receipts_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type = ?", 45])
    travel_claim_receipts.where(expenditure_type: 45).sum(:amount)
  end
  
  def other_claims_total
    #travel_claim_receipts.sum(:amount, :conditions => ["expenditure_type IN (?)", [41,42,43,44,45] ]) + exchange_loss_totals
    travel_claim_receipts.where("expenditure_type IN (?)", [41,42,43,44,45] ).sum(:amount) + exchange_loss_totals
  end
  
  def public_receipt_only
    travel_claim_receipts.where("expenditure_type IN (?)", [11,12,13,14,15]).sum(:amount)
  end
  
  def public_receipt_and_other_claims_receipt
    other_claims_total + public_receipt_only
  end
  
  def total_mileage
    travel_requests.sum(:log_mileage)
  end
  
  def total_km_money
    travel_requests.sum(:log_fare)
  end
  

    #[ "Telefon/Teleks/Fax",45 ],
  
  
  
  
  
  #  
end
