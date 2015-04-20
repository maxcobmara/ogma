class AddColumnToLessonplansearch < ActiveRecord::Migration
  def change
    add_column :lessonplansearches, :valid_schedule, :integer
  end
end
