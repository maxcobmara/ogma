class AddColumnToEvaluateCourse < ActiveRecord::Migration
  def change
    add_column :evaluate_courses, :visitor_id, :integer
  end
end
