class Bookingfacility < ActiveRecord::Base
  belongs_to :booked_facility, class_name: 'Location',  foreign_key: 'location_id'
  belongs_to :booking_staff, class_name: 'Staff', foreign_key: 'staff_id'
  belongs_to :approving_staff, class_name: 'Staff', foreign_key: 'approver_id'
  belongs_to :facility_officer, class_name: 'Staff', foreign_key: 'approver_id2'

  validates :location_id, :staff_id, :request_date, :start_date, :end_date, :total_participant, :purpose, presence: true  
  validates :total_participant, numericality: true
  validates :approval_date, :if => :reservation_approved?, presence: true
  validates :approval_date2, :if => :facility_approved?, presence: true
  validate :validate_end_date_before_start_date
  
  def reservation_dates
    "#{start_date.strftime('%d-%m-%Y %H:%M')} - #{end_date.strftime('%d-%m-%Y %H:%M')}"
  end
  
  def reservation_approved?
    approval==true
  end
  
  def facility_approved?
    approval2==true
  end
  
  def validate_end_date_before_start_date
    if end_date && start_date
      errors.add(:base, I18n.t('campus.bookingfacilities.begin_before_ends')) if end_date < start_date || start_date < DateTime.now
    end
  end
  
  def self.search2(search)
    if search
      where('staff_id=? OR approver_id=? OR approver_id2=?', search, search, search)
    end
  end
  
  def location_admin(staff_id)
    if User.where(userable_id: staff_id).first.roles.pluck(:authname).include?('facilities_administrator')
      location_ids=Location.where(staffadmin_id: staff_id).pluck(:id)
    else
      location_ids=[]
    end
    location_ids
  end

end
