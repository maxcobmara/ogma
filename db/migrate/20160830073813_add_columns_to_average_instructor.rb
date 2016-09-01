class AddColumnsToAverageInstructor < ActiveRecord::Migration
  def change
    add_column :average_instructors, :college_id, :integer
    add_column :average_instructors, :data, :text
    rename_column :average_instructors, :start_on, :start_at
    rename_column :average_instructors, :end_on, :end_at
    rename_column :average_instructors, :dq9reiew, :dq9review
  end
end
