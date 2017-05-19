class AssetDefect < ActiveRecord::Base
  include AssetDefectsHelper
  
  belongs_to :college
  belongs_to :asset
  belongs_to :reporter,   :class_name => 'Staff', :foreign_key => 'reported_by'
  belongs_to :processor,  :class_name => 'Staff', :foreign_key => 'processed_by'
  belongs_to :confirmer,   :class_name => 'Staff', :foreign_key => 'decision_by'
  
  validates :asset_id, :reported_by, :presence => true
  validates :processed_by, :process_type, :processed_on, :decision_by, presence: true, :if => :is_processed
  validates :decision_on, presence: true, :if => :decision
  
  attr_accessor :editing_page
  
  #define scope - asset(typename, name, modelname)
  def self.typemodelname_search(query)
    if query
      asset_ids = Asset.where('typename ILIKE(?) or name ILIKE(?) or modelname ILIKE(?)', "%#{query}%","%#{query}%","%#{query}%").pluck(:id)
      return AssetDefect.where('asset_id IN (?)', asset_ids)
    end
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:typemodelname_search]
  end
  
  def self.sstaff2(u)
     where('reported_by=? OR processed_by=? OR decision_by=?', u,u,u)
  end  
  
  #usage - equery - kewpa9 - below onwards
  def self.incharge_staffs
     defected_asset_ids = AssetDefect.pluck(:asset_id)
     incharge_ids_of_defected = Asset.where('assignedto_id is not null AND id IN(?)',defected_asset_ids).pluck(:assignedto_id).uniq
     staff_ids=Staff.pluck(:id)
     incharge_ids_of_defected2 = []
     incharge_ids_of_defected.each do |incharge| 
        incharge_ids_of_defected2 << incharge if staff_ids.include?(incharge) == true
     end
     incharge_ids_of_defected2
   end

   def asset_code
     asset.assetcode
   end
   
   def reported_name_rank
     "#{reporter.staff_with_rank}"
   end
   
   def reported_name_position
     "#{reporter.staff_name_with_position}"
   end
   
   def processor_name_rank
     "#{processor.staff_with_rank}"
   end
   
   def processor_name_position
     "#{processor.staff_name_with_position}"
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
