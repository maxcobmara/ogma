class AssetDisposal < ActiveRecord::Base
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
