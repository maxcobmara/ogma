class LocationDamage < ActiveRecord::Base
  belongs_to :location, :foreign_key => 'location_id'
  belongs_to :tenant, :foreign_key => 'user_id'
  belongs_to :asset, :foreign_key => 'college_id'
  
  validates_presence_of :reported_on, :description, :document_id
  
  attr_accessor :location_combocode, :damagetype, :dmgbytenant, :update_type
  
  def damage_type
    if document_id==1
     "#{ I18n.t('student.tenant.room_damage')}"
    elsif document_id==2
      "#{ I18n.t('student.tenant.asset_other_damage')}"
    end
  end
  
  # define scope
  def self.repaired_on_search(query) 
    if query=='1'
      cond_stat = 'repaired_on is not null'
    elsif query=='2'
      cond_stat = 'repaired_on is null'
    end
    where(cond_stat)   
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:repaired_on_search]
  end
  
  def description_assetcode
    d=description
    d+=" ("+asset.try(:assetcode)+")" unless college_id.nil?
    d
  end
  #shall collect all fields & didn't produce xls as formatted in index.xls.erb - use below instead
  #   def self.to_csv(options = {})
  #     CSV.generate(options) do |csv|
  #       csv << column_names
  #       all.each do |damage|
  #         csv << damage.attributes.values_at(*column_names)
  #       end
  #     end
  #   end 
  #use below------
  # https://deepakrip007.wordpress.com/2013/09/25/export-csvexcel-files-in-rails/
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
        csv << [I18n.t('location.damage.damage_report')] #title added
        csv << [] #blank row added
        csv << [I18n.t('location.combo_code'), I18n.t('student.tenant.damage_type'), I18n.t('location.damage.description'), I18n.t('location.damage.reported_on'), I18n.t('location.damage.repaired_on'), I18n.t('student.tenant.name')]   
        all.order(created_at: :desc).sort_by{|i|i.location.combo_code}.each do |damage|
          csv << [damage.try(:location).try(:combo_code),damage.damage_type, damage.description_assetcode, damage.reported_on.try(:strftime, '%d-%m-%Y'), damage.repaired_on.try(:strftime, '%d-%m-%Y'), damage.try(:tenant).try(:student).try(:name)]
        end
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
