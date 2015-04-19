class AddColumns2ToLessonplansearches < ActiveRecord::Migration
  def change
    add_column :lessonplansearches, :subject, :integer
    add_column :lessonplansearches, :loggedin_staff, :integer
  end
end
