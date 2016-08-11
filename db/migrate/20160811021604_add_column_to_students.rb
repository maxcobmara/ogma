class AddColumnToStudents < ActiveRecord::Migration
  def change
    add_column :students, :rank_id, :integer
  end
end
