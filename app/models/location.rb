class Location < ActiveRecord::Base
  
  before_validation     :set_combo_code
  before_save           :set_combo_code

  validates_presence_of  :code, :name
  validates :combo_code, uniqueness: true
  
  
  has_ancestry :cache_depth => true, orphan_strategy: :restrict
  belongs_to  :administrator, :class_name => 'Staff', :foreign_key => 'staffadmin_id'
  has_many  :tenants, :dependent => :destroy
  
  has_many :asset_placements
  has_many :assets, :through => :asset_placements
  
  
  def staff_name
    administrator.try(:name)
  end
  
  def staff_name=(name)
    self.administrator = Staff.find_by_name(name) if name.present?
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
  

  
end