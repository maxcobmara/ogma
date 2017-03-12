class ChangeColumnsToAverageCourse < ActiveRecord::Migration
  def change
    remove_column :average_courses, :organisation, :string
    remove_column :average_courses, :expertise_qualification,:string
  end
end
