class AssetLoan < ActiveRecord::Base
   
  before_save :set_staff_when_blank, :set_loaned_by
  
  belongs_to :asset, :foreign_key => 'asset_id'
  belongs_to :staff   #staff_id
  belongs_to :owner, :class_name => 'Staff', :foreign_key => 'loaned_by'
  belongs_to :loanofficer,   :class_name => 'Staff', :foreign_key => 'loan_officer'
  belongs_to :hodept,   :class_name => 'Staff', :foreign_key => 'hod'
  belongs_to :receivedpfficer, :class_name => 'Staff', :foreign_key => 'received_officer'
  
  validates_presence_of :reasons, :if => :must_assign_if_external?   #16July2013
  
  #scope :myloan, -> { where(staff_id: Login.current_login.staff_id)}
  scope :internal, -> { where(loantype: 1)}
  scope :external, -> { where(loantype: 2 )}
  scope :onloan, -> { where('is_approved IS TRUE AND is_returned IS NOT TRUE')}
  scope :pending, -> { where('is_approved IS NULL AND loan_officer IS NULL')}
  scope :rejected, -> { where('is_approved IS FALSE' )}
  scope :overdue, -> { where('is_approved IS TRUE AND is_returned IS NULL AND expected_on>=?',Date.today )}
  
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
