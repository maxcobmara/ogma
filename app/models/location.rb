class Location < ActiveRecord::Base
  
  has_ancestry :cache_depth => true, orphan_strategy: :restrict
  before_validation     :set_combo_code
  before_save           :set_combo_code, :set_status

  validates_presence_of  :code, :name
  validates :combo_code, uniqueness: true
  
  
  
  belongs_to  :administrator, :class_name => 'Staff', :foreign_key => 'staffadmin_id'
  has_many  :tenants, :dependent => :destroy
  has_many  :damages, :class_name => 'LocationDamage', :foreign_key => 'location_id', :dependent => :destroy
  
  has_many :asset_placements
  has_many :assets, :through => :asset_placements
  
  
  def staff_name
    administrator.try(:name)
  end
  
  def staff_name=(name)
    self.administrator = Staff.find_by_name(name) if name.present?
  end
  
  def parent_code
    parent.try(:combo_code)
  end
  
  def parent_code=(combo_code)
    self.parent = Location.find_by_combo_code(combo_code) if combo_code.present?
  end
  
  
  def translated_location_category
    I18n.t(location_category, :scope => :location_categories)
  end
  
  def set_combo_code
    if ancestry_depth == 0
      self.combo_code = code
    else
      self.combo_code = parent.combo_code + "-" + code
    end
  end
  
  def set_status
    if typename == 2
      bed_type = "student_bed_female"
    elsif typename == 8
      bed_type = "student_bed_male"
    end
    @occupied_location_ids = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true).pluck(:location_id)
    if damaged?
      status_type = "damaged"
    elsif @occupied_location_ids.include? id
      status_type = "occupied"
    else
      status_type = "empty"
    end
    self.status = "#{bed_type}_#{status_type}"
  end
  

  
end

# == Schema Information
#
# Table name: locations
#
#  allocatable    :boolean
#  ancestry       :string(255)
#  ancestry_depth :integer          default(0)
#  code           :string(255)
#  combo_code     :string(255)
#  created_at     :datetime
#  id             :integer          not null, primary key
#  lclass         :integer
#  name           :string(255)
#  occupied       :boolean
#  staffadmin_id  :integer
#  typename       :integer
#  updated_at     :datetime
#
