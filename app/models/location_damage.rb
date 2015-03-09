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
