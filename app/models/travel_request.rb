class TravelRequest < ActiveRecord::Base
  # befores, relationships, validations, before logic, validation logic, 
  #controller searches, variables, lists, relationship checking
  before_save :set_to_nil_where_false, :set_total, :set_mileage_nil_when_not_own_car, :set_own_car_false_if_no_car_registered
  
  belongs_to :applicant, :class_name => 'Staff', :foreign_key => 'staff_id'
  belongs_to :replacement, :class_name => 'Staff', :foreign_key => 'replaced_by'
  belongs_to :headofdept, :class_name => 'Staff', :foreign_key => 'hod_id'
  
  belongs_to :travel_claim, :foreign_key => 'travel_claim_id'
  belongs_to :document
  
  validates_presence_of :staff_id, :destination, :depart_at, :return_at
  validates_presence_of :own_car_notes, :if => :mycar?
  validate :validate_end_date_before_start_date, :staff_vehicle_must_exist_if_own_car
  validates_presence_of :replaced_by, :if => :check_submit?    #validation during EDIT - refer notes on EDIT & APPROVE button in SHOW page
  validates_presence_of :hod_id, :if => :check_submit?             #validation during EDIT - refer notes on EDIT & APPROVE button in SHOW page
  validates_presence_of :hod_accept_on, :if => :hod_accept?  #validation in APPROVAL page - refer notes on EDIT & APPROVE button in SHOW page
  
  has_many :travel_claim_logs, :dependent => :destroy
  accepts_nested_attributes_for :travel_claim_logs, :reject_if => lambda { |a| a[:destination].blank? }, :allow_destroy =>true
  validates_associated :travel_claim_logs#, :message=>"data is not complete."
  
  attr_accessor :staff_own_car, :tpt_class
  
  #controller searches
  def self.in_need_of_approval
    where('hod_id = ? AND is_submitted = ? AND (hod_accept IS ? OR hod_accept = ?)', User.current.userable_id, true, nil, false)
  end
  
  def self.my_travel_requests
    where(staff_id: User.current.userable_id)
  end
  
  def reference_document
    if document.blank?
      I18n.t('none_assigned')
    else
      document.refno+" : "+document.title+I18n.t("staff.travel_request.dated")+document.letterdt.try(:strftime,"%d %b %Y").to_s
    end
  end
  
  def repl_staff
    unit_name = User.current.userable.positions.first.unit
    siblings = Position.joins(:staff).where(unit: unit_name).pluck(:staff_id)  
    #children = User.current.userable.positions.first.children.pluck(:staff_id)
    replacements = siblings # + children #not suitable for Pn Nabilah, Pn Rokiah - Timbalan2 Pengarah
    replacements
  end
  
  def hods
    unit_name = User.current.userable.positions.first.unit
    applicant_post= User.current.userable.positions.first
    prog_names = Programme.roots.map(&:name)
     #common_subjects = Programme.find(:all, :conditions=>['course_type=?', "Common Subject"]).map(&:name)  #no yet exist in programme & name format not sure 2
    common_subjects=["Komunikasi & Sains Pengurusan", "Sains Tingkahlaku", "Anatomi & Fisiologi", "Sains Perubatan Asas"]
    approver=[]
    if prog_names.include?(unit_name) || unit_name == "Pos Basik" || common_subjects.include?(unit_name)
      if applicant_post.tasks_main.include?("Ketua Program") || applicant_post.tasks_main.include?("Ketua Subjek")
        approver = User.current.userable.positions.first.parent.staff_id
      else
        sib_pos = Position.where('unit=? and staff_id is not null',unit_name).order(combo_code: :asc)
        if sib_pos
          sib_pos.each do |sp|
            approver << sp.staff_id if sp.tasks_main.include?("Ketua Program") || applicant_post.tasks_main.include?("Ketua Subjek")
          end
        end
      end
    else
      staffapprover = Position.where('unit=? and combo_code<? and ancestry_depth!=?', unit_name, applicant_post.combo_code,1).map(&:staff_id)
      #Above : ancestry_depth!= 1 to avoid Timbalan2 Pengarah - fr becoming each other's hod.
      approvers= Staff.where('id IN(?)', staffapprover)
      approvers.each_with_index do |ap,idx|
        approver << ap.id if ap.staffgrade.name.scan(/\d+/).first.to_i > 26  #check if approver realy qualified one 
      end
      approver << User.current.userable.positions.first.parent.staff_id if approver.count==0
      approver << User.current.userable.positions.first.ancestors.map(&:staff_id) if approver.count==0
    end
    #override all above approver - 23Dec2014 - do not remove above yet, may be useful for other submodules
    hod_posts = Position.where('ancestry_depth<?',2)
    approver=[] 
    hod_posts.each do |hod|
      approver << hod.staff_id if (hod.name.include?("Pengarah")||(hod.name.include?("Timbalan Pengarah")) && hod.staff_id!=nil)
    end
    approver
  end
  
  def gcode(generated_code)
    if id.nil? || id.blank?
      @gcode = generated_code
    else
      @gcode = code
    end
    @gcode
  end
  
  #autocomplete
  #def document_refno
    #document.refno if document
  #end
  
  #def document_refno=(refno)
    #self.document = Document.find_by_refno(refno) unless refno.blank?
  #end
  
  #before logic
  def set_to_nil_where_false
    if is_submitted == true
      self.submitted_on= Date.today
      if mileage == true
        self.mileage_history = 1
      elsif mileage == false
        self.mileage_history = 2
      end
    end
    
    if hod_accept == false
      self.hod_accept_on	= nil
    end
    
    if !mycar?#own_car == false 
      self.own_car_notes =''
      self.mileage = nil
    end
    
    if mileage_replace == false #decision by hod
      self.mileage = true
    elsif mileage_replace == true
      self.mileage = false
    end
  end
  
  def set_mileage_nil_when_not_own_car
    #true for mileage allowance
    #false for mileage replacement
    unless own_car
      self.mileage_replace = nil
    end
  end
  
  def set_total
    self.log_mileage = total_mileage_request
    self.log_fare = total_km_money_request
  end
  
  def set_own_car_false_if_no_car_registered
    if applicant.vehicles.blank? && own_car==true
      self.own_car = false
    end
  end
  
  #validation logic
  def validate_end_date_before_start_date
    if return_at && depart_at
      errors.add(:depart_at, "Your must leave before you return") if return_at < depart_at
    end
  end
  
  def staff_vehicle_must_exist_if_own_car
    if own_car == true && User.current.userable.vehicles.count==0
      errors.add(I18n.t('staff.vehicles.title'), I18n.t('staff.travel_request.vehicle_must_exist'))
    end
  end
  
  def mycar?
    own_car == true #&& (!applicant.blank? && !applicant.vehicles.blank?)
  end
  
  def check_submit?
    is_submitted == true
  end
  
  def requires_approval
    if hod_accept == nil && hod_id == Login.current_login.staff_id
      (link_to image_tag("approval.png", :border => 0), :action => 'edit', :id => travel_request).to_s
    elsif is_submitted == true && hod_accept == nil && staff_id == Login.current_login.staff_id
      ""
    elsif is_submitted == false || is_submitted == nil
      (link_to image_tag("edit.png", :border => 0), :action => 'edit', :id => travel_request).to_s
    else
    end
  end
  
  def total_mileage_request
    #other_claims_total + public_transport_totals
    travel_claim_logs.sum(:mileage)
  end
  
  def total_km_money_request
    #other_claims_total + public_transport_totals
    travel_claim_logs.sum(:km_money)
  end
  
  def travel_dates
    "#{depart_at.try(:strftime, "%d %b %Y")}"+" - "+"#{ return_at.try(:strftime, "%d %b %Y") }"
  end
  
  def transport_class
    abc = TravelClaimsTransportGroup.abcrate
    de = TravelClaimsTransportGroup.derate
    mid = 1820.75
    if applicant.nil? || applicant.blank?
      app2 = Staff.where(id: User.current.userable.id).first
      if app2.vehicles && app2.vehicles.count>0
        TravelClaimsTransportGroup.transport_class(app2.vehicles.first.id, app2.current_salary, abc, de, mid)
      else
        'Z'
      end
    else
      if applicant.vehicles && applicant.vehicles.count>0
        TravelClaimsTransportGroup.transport_class(applicant.vehicles.first.id, applicant.current_salary, abc, de, mid)
      else
        'Z'
      end
    end
  end
  
  def depart_return
    if depart_at!=nil && return_at!=nil
      "#{depart_at.try(:strftime, '%d %b %Y')} - #{return_at.try(:strftime, '%d %b %Y')}"
    end
  end
  
end