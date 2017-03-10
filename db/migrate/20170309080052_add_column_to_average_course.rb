class AddColumnToAverageCourse < ActiveRecord::Migration
  def change
    add_column :average_courses, :visitor_id, :integer
  end
end
