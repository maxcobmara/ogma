class AddColumnsToAverageCourses < ActiveRecord::Migration
  def change
    remove_column :average_courses, :dissatisfaction, :string
    remove_column :average_courses, :recommend_for_improvement, :string
    remove_column :average_courses, :support_justify, :string
    add_column :average_courses, :dissatisfaction, :text
    add_column :average_courses, :recommend_for_improvement, :text
    add_column :average_courses, :support_justify, :text
    add_column :average_courses, :college_id, :integer
    add_column :average_courses, :data, :text
  end
end
