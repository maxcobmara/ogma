class AddColumn2ToPtcourses < ActiveRecord::Migration
  def change
    add_column :ptcourses, :level, :integer
  end
end
