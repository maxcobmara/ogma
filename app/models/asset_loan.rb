class AssetLoan < ActiveRecord::Base
   
  before_save :set_loaned_by_and_hod
  
  belongs_to :asset, :foreign_key => 'asset_id'
  belongs_to :staff, :foreign_key => 'staff_id'   #peminjam / loaner
  belongs_to :owner, :class_name => 'Staff', :foreign_key => 'loaned_by'
  belongs_to :loanofficer,   :class_name => 'Staff', :foreign_key => 'loan_officer'
  belongs_to :hodept,   :class_name => 'Staff', :foreign_key => 'hod'
  belongs_to :receivedofficer, :class_name => 'Staff', :foreign_key => 'received_officer'
  belongs_to :driver, :class_name => 'Staff', :foreign_key => 'driver_id'
  
  validates_presence_of :loaned_on, :staff_id, :expected_on
  validates_presence_of :loantype, :if => :other_asset?
  validates_presence_of :reasons, :if => :must_assign_if_external?   
  validates_presence_of :reasons, :driver_id, :if => :must_assign_if_vehicle?
  validates_presence_of :endorsed_date,  :loan_officer, :if => :is_endorsed?
  validates_presence_of :approved_date, :hod, :if => :is_approved?
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
    elsif query =='0'
      loanstatus = AssetLoan.all
    end 
    loanstatus
  end
  
  def self.category_search(query)
    vehicle_ids=Asset.vehicle.pluck(:id)
    if query== '1'
      assetcategory=where(asset_id: vehicle_ids)
    elsif query=='2'
      assetcategory=where.not(asset_id: vehicle_ids)
    else
      assetcategory=AssetLoan.all
    end
    assetcategory
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search, :status_search, :category_search]
  end
  
  def must_assign_if_external?  #16July2013
    loantype==2 
  end
  
  def must_assign_if_vehicle?
    asset.category_id==3 || asset.category.description.downcase.include?('kenderaan')
  end
  
  def other_asset?
    !(asset.category_id==3 || asset.category.description.downcase.include?('kenderaan'))
  end
  
  def self.borrowings
    find(:all, :conditions => ['is_returned !=? OR is_approved IS NOT ?', true, nil])
  end
  
  def self.sstaff2(u)
    bb=User.where(userable_id: u).first.vehicle_unit_members
    aa=User.where(userable_id: u).first.unit_members
    where('staff_id=? OR loaned_by=? OR loan_officer=? OR hod=? OR received_officer=? OR loaned_by IN(?) OR loaned_by IN(?)', u,u,u,u,u,aa,bb)
  end
  
  def set_loaned_by_and_hod
    if loaned_by.blank?
      self.loaned_by = asset.assignedto_id
    end
    self.hod= Staff.joins(:positions).where('positions.unit=?', 'Ketua Tadbir Bantuan Operasi Latihan').first.id
  end
  
  def loaner
     if staff_id.blank?
       Login.current_login.staff.staff_name_with_position
     else
       staff.staff_name_with_position
     end
  end
   
  def unit_members
    #exist_unit_of_staff_in_position = Position.where('unit is not null and staff_id is not null').pluck(:staff_id).uniq
    exist_unit_of_staff_in_position = Position.where('unit is not null and staff_id=?',self.loaned_by).pluck(:staff_id).uniq
    #if exist_unit_of_staff_in_position.include?(self.loaned_by)
    if exist_unit_of_staff_in_position.count > 0
      current_unit = Position.where(staff_id: self.loaned_by).first.try(:unit)
      if current_unit
        unit_members = Position.where(unit: current_unit).pluck(:staff_id).uniq-[nil]
      else
        unit_members =[]
      end
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
