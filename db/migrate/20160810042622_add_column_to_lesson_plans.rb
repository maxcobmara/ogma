class AddColumnToLessonPlans < ActiveRecord::Migration
  def change
    add_column :lesson_plans, :data_title, :string
  end
end
