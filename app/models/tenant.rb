class Tenant < ActiveRecord::Base
  before_save :save_my_vars
  belongs_to :location, touch: true
  belongs_to :staff
  belongs_to :student
  has_many  :damages, :class_name => 'LocationDamage', :foreign_key => 'user_id', :dependent => :destroy
  accepts_nested_attributes_for :damages, :allow_destroy => true, reject_if: proc { |damages| damages[:description].blank?}
  
  
  #student autocomplete
  def student_icno
    student.try(:student_list)
  end

  def student_icno=(icno)
    icno2 = icno.split(" ")[0]
    #self.student = Student.find_or_create_by_icno(icno2) if icno2.present?
    self.student = Student.find_or_create_by(icno: icno2) if icno2.present?
  end
  
  def save_my_vars
    if id.nil? || id.blank?
      self.force_vacate = 0
    end
  end
  
  # define scope
  def self.keyword_search(query)
    aaa=LocationDamage.where('user_id is not null').pluck(:user_id)
    tenant_ids = LocationDamage.where('user_id is not null').pluck(:user_id) if query=='1'   #w dmgs
    tenant_ids = Tenant.where('id not IN(?)', aaa).pluck(:id) if query=='2'                               #wo dmgs
    where('tenants.id IN(?)', tenant_ids) 
  end
  
  def self.damagetype_search(query)
    if query=='1' 
      tenant_ids = LocationDamage.where('document_id=?', 1).pluck(:user_id)  #oom_damage
    elsif query=='2'
      tenant_ids = LocationDamage.where('document_id=?', 2).pluck(:user_id)  #asset_other_damage
    end
    where('tenants.id IN(?)', tenant_ids) 
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:keyword_search, :damagetype_search]
  end
  
end

# == Schema Information
#
# Table name: tenants
#
#  created_at        :datetime
#  force_vacate      :boolean
#  id                :integer          not null, primary key
#  keyaccept         :date
#  keyexpectedreturn :date
#  keyreturned       :date
#  location_id       :integer
#  staff_id          :integer
#  student_id        :integer
#  updated_at        :datetime
#
