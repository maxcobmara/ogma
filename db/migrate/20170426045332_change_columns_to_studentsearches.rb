class ChangeColumnsToStudentsearches < ActiveRecord::Migration
  def change
    remove_column :studentsearches, :intake, :date
    add_column :studentsearches, :intake, :integer
  end
end
