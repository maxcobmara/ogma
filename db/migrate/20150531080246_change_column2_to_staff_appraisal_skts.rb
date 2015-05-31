class ChangeColumn2ToStaffAppraisalSkts < ActiveRecord::Migration
  def change
    remove_column :staff_appraisal_skts, :description, :string
    add_column :staff_appraisal_skts, :description, :text
  end
end
