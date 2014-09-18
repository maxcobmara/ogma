class AssetLoss < ActiveRecord::Base
  
  belongs_to :location
  belongs_to :asset
  belongs_to :document
  belongs_to :hod,              :class_name => 'Staff', :foreign_key => 'endorsed_hod_by'
  belongs_to :handled_by,       :class_name => 'Staff', :foreign_key => 'last_handled_by' 
end

# == Schema Information
#
# Table name: asset_losses
#
#  asset_id                   :integer
#  cash_type                  :string(255)
#  created_at                 :datetime
#  document_id                :integer
#  endorsed_hod_by            :integer
#  endorsed_on                :date
#  est_value                  :decimal(, )
#  form_type                  :boolean
#  how_desc                   :text
#  id                         :integer          not null, primary key
#  investigated_by            :integer
#  investigation_code         :string(255)
#  investigation_completed_on :date
#  is_police_report_made      :boolean
#  is_prima_facie             :boolean
#  is_rule_broken             :boolean
#  is_staff_action            :boolean
#  is_submit_to_hod           :boolean
#  is_used                    :boolean
#  is_writeoff                :boolean
#  last_handled_by            :integer
#  location_id                :integer
#  loss_type                  :string(255)
#  lost_at                    :datetime
#  new_measures               :text
#  notes                      :text
#  ownership                  :string(255)
#  police_action_status       :text
#  police_report_code         :string(255)
#  prev_action_enforced_by    :integer
#  preventive_action_dept     :text
#  preventive_measures        :text
#  recommendations            :text
#  report_code                :string(255)
#  rules_broken_desc          :text
#  security_code              :string(255)
#  security_officer_id        :integer
#  security_officer_notes     :text
#  surcharge_notes            :text
#  updated_at                 :datetime
#  value_federal              :decimal(, )
#  value_state                :decimal(, )
#  why_no_report              :text
#
