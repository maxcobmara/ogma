class ChangeColumnToLessonPlan < ActiveRecord::Migration
  def change 
    remove_column :lesson_plans, :data, :text
    add_column :lesson_plans, :college_data, :text
  end
end
