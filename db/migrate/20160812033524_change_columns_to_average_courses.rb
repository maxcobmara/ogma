class ChangeColumnsToAverageCourses < ActiveRecord::Migration
  def change
    rename_column :average_courses, :summary_evaluation, :lesson_content
    rename_column :average_courses, :dissactifaction, :dissatisfaction
    add_column :average_courses, :organisation, :string
    add_column :average_courses, :expertise_qualification, :string
    remove_column :average_courses, :evaluate_category, :string
    add_column :average_courses, :evaluation_category, :boolean
  end
end
