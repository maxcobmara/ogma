class AddColumns2ToEvaluateCourses < ActiveRecord::Migration
  def change
    add_column :evaluate_courses, :ev_assessment, :integer
  end
end
