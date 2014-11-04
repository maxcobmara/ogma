class AssetLoan < ActiveRecord::Base
   
  before_save :set_staff_when_blank, :set_loaned_by
  
  belongs_to :asset, :foreign_key => 'asset_id'
  belongs_to :staff, :foreign_key => 'staff_id'   #peminjam / loaner
  belongs_to :owner, :class_name => 'Staff', :foreign_key => 'loaned_by'
  belongs_to :loanofficer,   :class_name => 'Staff', :foreign_key => 'loan_officer'
  belongs_to :hodept,   :class_name => 'Staff', :foreign_key => 'hod'
  belongs_to :receivedofficer, :class_name => 'Staff', :foreign_key => 'received_officer'
  
  validates_presence_of :loantype
  validates_presence_of :reasons, :if => :must_assign_if_external?   
  validates_presence_of :hod, :if => :is_approved?
  validates_presence_of :returned_on, :received_officer, :if => :is_returned?
  
  #scope :myloan, -> { where(staff_id: Login.current_login.staff_id)}
  scope :internal, -> { where(loantype: 1)}
  scope :external, -> { where(loantype: 2 )}
  scope :onloan, -> { where('is_approved IS TRUE AND is_returned IS NOT TRUE')}
  scope :pending, -> { where('is_approved IS NULL AND loan_officer IS NULL')}
  scope :rejected, -> { where('is_approved IS FALSE' )}
  scope :overdue, -> { where('is_approved IS TRUE AND is_returned IS NULL AND expected_on<?',Date.today)}
  
  # define scope
  def self.keyword_search(query) 
    asset_ids = Asset.where('assetcode ILIKE (?) OR name ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id).uniq
    where('asset_id IN(?)', asset_ids)
  end
  
  def self.status_search(query)
    if query == '1'
      loanstatus = where('is_approved IS TRUE AND is_returned IS NOT TRUE')
    elsif query == '2'
      loanstatus = where('is_approved IS NULL AND loan_officer IS NULL')
    elsif query == '3'
      loanstatus = where('is_approved IS FALSE' )
    elsif query == '4'
      loanstatus =  where('is_approved IS TRUE AND is_returned IS NULL AND expected_on<?',Date.today)
    elsif query == '5'
      loanstatus = where('is_approved IS TRUE AND is_returned IS NULL AND expected_on=?',Date.today)
    elsif query == '6'
      loanstatus = where('is_approved IS TRUE AND is_returned IS TRUE')
    else
      loanstatus = AssetLoan.all
    end 
    loanstatus
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search, :status_search]
  end
  
  def must_assign_if_external?  #16July2013
    loantype==2 
  end
  
  def self.borrowings
    find(:all, :conditions => ['is_returned !=? OR is_approved IS NOT ?', true, nil])
  end
  
  
  def set_staff_when_blank
    if staff_id.blank?
      self.staff_id = Login.current_login.staff_id
    end
  end
  
  def set_loaned_by
    if loaned_by.blank?
      self.loaned_by = asset.assignedto_id
    end
  end
  
  def loaner
     if staff_id.blank?
       Login.current_login.staff.staff_name_with_position
     else
       staff.staff_name_with_position
     end
  end
   
  def unit_members
    exist_unit_of_staff_in_position = Position.where('unit is not null and staff_id is not null').pluck(:staff_id).uniq
    if exist_unit_of_staff_in_position.include?(self.loaned_by)
      current_unit = Position.where(staff_id: self.loaned_by).unit
      unit_members = Position.where(unit: unit_hod).pluck(:staff_id).uniq-[nil]
    else
      unit_members = []#Position.where(unit: 'Teknologi Maklumat').pluck(:staff_id).uniq-[nil]  
    end
    unit_members    #collection of staff_id (member of a unit/dept)
  end
  
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
