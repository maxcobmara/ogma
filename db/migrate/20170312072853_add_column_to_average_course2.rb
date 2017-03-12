class AddColumnToAverageCourse2 < ActiveRecord::Migration
  def change
    add_column :average_courses, :invite_lec_topic, :string
  end
end
