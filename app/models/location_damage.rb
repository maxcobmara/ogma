class LocationDamage < ActiveRecord::Base
  belongs_to :location, :foreign_key => 'location_id'
  belongs_to :tenant, :foreign_key => 'user_id'
  
  validates_presence_of :reported_on, :description, :document_id
  
  def damage_type
    if document_id==1
     "#{ I18n.t('student.tenant.room_damage')}"
    elsif document_id==2
      "#{ I18n.t('student.tenant.asset_other_damage')}"
    end
  end
  
  # define scope
  def self.keyword_search(query)
    aaa=LocationDamage.where('user_id is not null').pluck(:user_id)
    tenant_ids = LocationDamage.where('user_id is not null').pluck(:user_id) if query=='1'   #w dmgs
    tenant_ids = Tenant.where('id not IN(?)', aaa).pluck(:id) if query=='2'                               #wo dmgs
    where('tenants.id IN(?)', tenant_ids) 
  end
  
#   def self.damagetype_search(query)
#     if query=='1' 
#       tenant_ids = LocationDamage.where('document_id=?', 1).pluck(:user_id)  #oom_damage
#     elsif query=='2'
#       tenant_ids = LocationDamage.where('document_id=?', 2).pluck(:user_id)  #asset_other_damage
#     end
#     where('tenants.id IN(?)', tenant_ids) 
#   end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
#     [:keyword_search, :damagetype_search]
    [:keyword_search]
  end
  
end

# == Schema Information
#
# Table name: location_damages
#
#  college_id    :integer
#  created_at    :datetime
#  description   :string(255)
#  document_id   :integer
#  id            :integer          not null, primary key
#  inspection_on :date
#  location_id   :integer
#  repaired_on   :date
#  reported_on   :date
#  updated_at    :datetime
#  user_id       :integer
#
