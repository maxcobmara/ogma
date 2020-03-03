class TravelClaim < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  before_save :set_to_nil_where_false, :set_total
  before_destroy :remove_claim_from_travel_request
  
  belongs_to :staff
  belongs_to :approver,           :class_name => 'Staff',      :foreign_key => 'approved_by'
  belongs_to :checker,            :class_name => 'Staff',      :foreign_key => 'checked_by'
  
  has_many :travel_requests
  accepts_nested_attributes_for :travel_requests
  
  has_many :travel_claim_receipts, :dependent => :destroy
  accepts_nested_attributes_for :travel_claim_receipts, :reject_if => lambda { |a| a[:amount].blank? }, :allow_destroy =>true #must include for Update too
  
  #has_many :travel_claim_logs, :through => :travel_requests
  
  has_many :travel_claim_allowances, :dependent => :destroy
  accepts_nested_attributes_for :travel_claim_allowances, :reject_if => lambda { |a| a[:amount].blank? }, :allow_destroy =>true #must include for Update too
  
  #validates_presence_of :travel_requests, :message => I18n.t('staff.travel_claim.travel_requests_must_exist')
  validates_uniqueness_of :claim_month, :scope => :staff_id, :message => I18n.t('staff.travel_claim.claim_exist')
  validate :accommodations_must_exist_for_lodging_hotel_claims
  
  attr_accessor :jobtype

  def set_to_nil_where_false
    if is_submitted == true
      self.submitted_on= Date.today
      #owner resubmit amended form
      if is_checked == false && jobtype=="editing" #staff_id==Login.current_login.staff_id  #during resubmission of amended form by owner
        self.is_returned = false 
      end
      #check part?
      if is_checked == false && jobtype=="checking"#staff_id != Login.current_login.staff_id  #2nd time return by finance
        self.is_returned = true
      end
      if is_checked == true && jobtype=="checking"#staff_id != Login.current_login.staff_id
        self.checked_on = Date.today
      end
    else
      self.submitted_on= nil
    end
  end
  
  def hods
    hod_posts = Position.where('ancestry_depth<?',2)
    approver=[] 
    hod_posts.each do |hod|
      approver << hod.staff_id if (hod.name.include?("Pengarah")||(hod.name.include?("Timbalan Pengarah")) && hod.staff_id!=nil)
    end
    approver
  end
  
  def remove_claim_from_travel_request
    travel_requests_ids=TravelRequest.where(travel_claim_id: id).pluck(:id)
    TravelRequest.where(id: travel_requests_ids).update_all(travel_claim_id: nil)
  end
  
  def set_total
    self.total = total_claims
  end
  
  def self.sstaff2(u)
     where('staff_id=? OR checked_by=? OR approved_by=?', u,u,u)
  end   
  
  def accommodations_must_exist_for_lodging_hotel_claims
     duplicates = (travel_claim_allowances.map(&:expenditure_type) & [31,32]).count
     if duplicates > 0 && (accommodations.nil? || accommodations.blank?)
      errors.add(:base, I18n.t('staff.travel_claim.address_required'))
    end
  end
  
  def my_claim_status(current_user)
    if staff_id == current_user.userable.id && is_submitted != true  && is_checked == nil
      I18n.t('staff.travel_claim.editing') #"editing"
    elsif staff_id != current_user.userable.id && is_submitted != true && is_checked == nil #add-in to make sure it work with - those HACK part in index page - to differentiate with "editing" & login as finance staff
      I18n.t('staff.travel_claim.editing_by_staff') #"editing by staff"
    elsif staff_id == current_user.userable.id && is_submitted == true && is_checked == nil
      I18n.t('staff.travel_claim.submitted') #"submitted"
    elsif staff_id != current_user.userable.id && is_submitted == true && is_checked == nil
      I18n.t('staff.travel_claim.for_checking') #"for checking"
    elsif staff_id == current_user.userable.id && is_submitted == false && is_checked == false && is_returned == true #owner amend returned document but did not submit
      I18n.t('staff.travel_claim.returned') #"returned"
    elsif staff_id == current_user.userable.id && is_submitted == true && is_checked == false && is_returned == true #owner amend returned document & re-SUBMIT
      I18n.t('staff.travel_claim.returned') #"returned"
    elsif staff_id == current_user.userable.id && is_submitted == true && is_checked == false && is_returned == false 
      I18n.t('staff.travel_claim.resubmitted_to_finance')#"resubmitted to finance"
    elsif staff_id != current_user.userable.id && is_submitted == true && is_checked == false	&& is_returned == false 
      I18n.t('staff.travel_claim.for_checking') # "for checking"
    elsif is_submitted == true && is_checked == true && is_approved != true
      I18n.t('staff.travel_claim.processed') #"processed"
    elsif is_submitted == true && is_checked == true && is_approved == true
      I18n.t('staff.travel_claim.approved') #"approved"
    elsif staff_id != current_user.userable.id && is_submitted == true && is_checked ==false && is_returned == true 
      I18n.t('staff.travel_claim.return_to_staff_for_amendment') #"return to staff for amendment"
    else
      I18n.t('staff.travel_claim.status_not_known') #"status not known"
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
    travel_claim_receipts.where(expenditure_type: 42).sum(:amount)
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

# == Schema Information
#
# Table name: travel_claims
#
#  accommodations :text
#  advance        :decimal(, )
#  approved_by    :integer
#  approved_on    :date
#  checked_by     :integer
#  checked_on     :date
#  claim_month    :date
#  created_at     :datetime
#  id             :integer          not null, primary key
#  is_approved    :boolean
#  is_checked     :boolean
#  is_returned    :boolean
#  is_submitted   :boolean
#  notes          :string(255)
#  staff_id       :integer
#  submitted_on   :date
#  total          :decimal(, )
#  updated_at     :datetime
#
