class AddColumnsToEvaluateCourses < ActiveRecord::Migration
  def change
    add_column :evaluate_courses, :invite_lec_topic, :string
  end
end
