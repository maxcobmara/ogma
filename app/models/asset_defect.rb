class AssetDefect < ActiveRecord::Base
  include AssetDefectsHelper
  
  belongs_to :asset
  belongs_to :reporter,   :class_name => 'Staff', :foreign_key => 'reported_by'
  belongs_to :processor,  :class_name => 'Staff', :foreign_key => 'processed_by'
  belongs_to :confirmer,   :class_name => 'Staff', :foreign_key => 'decision_by'
  
  validates :asset_id, :reported_by, :presence => true
  validates :processed_by, :process_type, :processed_on, presence: true, :if => :is_processed
  validates :decision_by, :decision_on, presence: true, :if => :decision
  
  attr_accessor :editing_page
  
  #define scope - asset(typename, name, modelname)
  def self.typemodelname_search(query)
    asset_ids = Asset.where('typename ILIKE(?) or name ILIKE(?) or modelname ILIKE(?)', "%#{query}%","%#{query}%","%#{query}%").pluck(:id)
    return AssetDefect.where('asset_id IN (?)', asset_ids)
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:typemodelname_search]
  end
  
end

# == Schema Information
#
# Table name: asset_defects
#
#  asset_id       :integer
#  created_at     :datetime
#  decision       :boolean
#  decision_by    :integer
#  decision_on    :date
#  description    :text
#  id             :integer          not null, primary key
#  is_processed   :boolean
#  notes          :text
#  process_type   :string(255)
#  processed_by   :integer
#  processed_on   :date
#  recommendation :text
#  reported_by    :integer
#  updated_at     :datetime
#
