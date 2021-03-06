class AssetDisposal < ActiveRecord::Base
    include AssetDisposalsHelper
  
    belongs_to :asset
    belongs_to :document
    belongs_to :inspect1or, :class_name => 'Staff', :foreign_key => 'examiner_staff1'
    belongs_to :inspect2or, :class_name => 'Staff', :foreign_key => 'examiner_staff2'
    belongs_to :processor, :class_name => 'Staff', :foreign_key => 'checked_by'
    #belongs_to :actioner, :class_name => 'Staff', :foreign_key => 'disposed_by'
    belongs_to :verifier,  :class_name => 'Staff', :foreign_key => 'verified_by'
    belongs_to :revaluer,  :class_name => 'Staff', :foreign_key => 'revalued_by'
    belongs_to :staff, :foreign_key => 'disposed_by'
    belongs_to :discard_witness1,  :class_name => 'Staff', :foreign_key => 'discard_witness_1'
    belongs_to :discard_witness2,  :class_name => 'Staff', :foreign_key => 'discard_witness_2'
    
    validates :asset_id, :current_value, presence: true
    validates :examiner_staff1, presence: true, :if => :is_staff1?
    validates :examiner_staff2, presence: true, :if => :is_staff2?
    validates :checked_by, :checked_on, :verified_by, presence: true, :if => :is_checked?
    validates :type_others_desc, presence: true, :if => :disposaltype_others?
    validates :verified_on, presence: true, :if => :is_verified?
    validates :revalued_on, presence: true, :if => :revalue?
    validates :disposed_by, presence: true, :if => :disposed_on?
    validates :disposed_on, presence: true, :if => :disposed_by?
    validates :current_value, presence: true
    #validates :discard_options, presence: true, :if => :disposal_type_is_discard?
    
    attr_accessor :editing_page
    
    def disposaltype_others?
      disposal_type=='others'
    end

#TODO    
#     def disposal_type_is_discard?
#       disposal_type=='discard'
#     end
    
    #define scope - asset(typename, name, modelname)
    def self.typemodelname_search(query)
      asset_ids = Asset.where('typename ILIKE(?) or name ILIKE(?) or modelname ILIKE(?)', "%#{query}%","%#{query}%","%#{query}%").pluck(:id)
      return AssetDisposal.where('asset_id IN (?)', asset_ids)
    end
    
   # whitelist the scope
    def self.ransackable_scopes(auth_object = nil)
      [:typemodelname_search]
    end
    
    def for_disposal
      exist_disposed=AssetDisposal.all.pluck(:asset_id)
      defective_for_dispose=AssetDefect.where('process_type=? and decision=?', 'dispose', true).pluck(:asset_id)
      if id.nil? || id.blank?
        return defective_for_dispose-exist_disposed
      else
        return defective_for_dispose-exist_disposed+[asset_id]
      end
    end
    
end

# == Schema Information
#
# Table name: asset_disposals
#
#  asset_defect_id       :integer
#  asset_id              :integer
#  checked_by            :integer
#  checked_on            :date
#  created_at            :datetime
#  current_condition     :string(255)
#  current_value         :decimal(, )
#  description           :text
#  discard_location      :string(255)
#  discard_options       :string(255)
#  discard_witness_1     :integer
#  discard_witness_2     :integer
#  discarded_on          :date
#  disposal_type         :string(255)
#  disposed_by           :integer
#  disposed_on           :date
#  document_id           :integer
#  documentation_no      :string(255)
#  est_repair_cost       :decimal(, )
#  est_time_next_fail    :decimal(, )
#  est_value_post_repair :decimal(, )
#  examiner1             :string(255)
#  examiner2             :string(255)
#  examiner_staff1       :integer
#  examiner_staff2       :integer
#  id                    :integer          not null, primary key
#  inform_hod            :integer
#  is_checked            :boolean
#  is_discarded          :boolean
#  is_disposed           :boolean
#  is_staff1             :boolean
#  is_staff2             :boolean
#  is_verified           :boolean
#  justify1_disposal     :string(255)
#  justify2_disposal     :string(255)
#  justify3_disposal     :string(255)
#  mileage               :integer
#  quantity              :integer
#  receiver_name         :string(255)
#  repair1_needed        :string(255)
#  repair2_needed        :string(255)
#  repair3_needed        :string(255)
#  revalue               :decimal(, )
#  revalued_by           :integer
#  revalued_on           :date
#  running_hours         :integer
#  type_others_desc      :string(255)
#  updated_at            :datetime
#  verified_by           :integer
#  verified_on           :date
#  witness_is_staff1     :boolean
#  witness_is_staff2     :boolean
#  witness_outsider1     :string(255)
#  witness_outsider2     :string(255)
#
