class ChangeColumns2ToStaffAppraisalSkts < ActiveRecord::Migration
  def change
    remove_column :staff_appraisal_skts, :indicator, :integer
    remove_column :staff_appraisal_skts, :target, :string
    add_column :staff_appraisal_skts, :indicator_desc_quality, :string
    add_column :staff_appraisal_skts, :indicator_desc_time, :string
    add_column :staff_appraisal_skts, :indicator_desc_quantity, :string
    add_column :staff_appraisal_skts, :indicator_desc_cost, :string
    add_column :staff_appraisal_skts, :target_quality, :string
    add_column :staff_appraisal_skts, :target_time, :string
    add_column :staff_appraisal_skts, :target_quantity, :string
    add_column :staff_appraisal_skts, :target_cost, :string
    remove_column :staff_appraisal_skts, :acheivment, :string
    remove_column :staff_appraisal_skts, :progress, :decimal
    remove_column :staff_appraisal_skts, :notes, :text
    add_column :staff_appraisal_skts, :achievement_quality, :string
    add_column :staff_appraisal_skts, :achievement_time, :string
    add_column :staff_appraisal_skts, :achievement_quantity, :string
    add_column :staff_appraisal_skts, :achievement_cost, :string
    add_column :staff_appraisal_skts, :progress_quality, :decimal
    add_column :staff_appraisal_skts, :progress_time, :decimal
    add_column :staff_appraisal_skts, :progress_quantity, :decimal
    add_column :staff_appraisal_skts, :progress_cost, :decimal
    add_column :staff_appraisal_skts, :notes_quantity, :string
    add_column :staff_appraisal_skts, :notes_time, :string
    add_column :staff_appraisal_skts, :notes_quality, :string
    add_column :staff_appraisal_skts, :notes_cost, :string
  end
end
