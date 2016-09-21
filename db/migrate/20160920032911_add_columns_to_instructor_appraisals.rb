class AddColumnsToInstructorAppraisals < ActiveRecord::Migration
  def change
    add_column :instructor_appraisals, :college_id, :integer
    add_column :instructor_appraisals, :data, :text
  end
end
