class ChangeColumnsToStaffAppraisalSkts < ActiveRecord::Migration
  def change
    remove_column :staff_appraisal_skts, :indicator 
    add_column :staff_appraisal_skts, :indicator, :integer
    add_column :staff_appraisal_skts, :target, :string
  end
end
