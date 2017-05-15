class ChangeColumnToStudentdisciplinesearch < ActiveRecord::Migration
  def change
    remove_column :studentdisciplinesearches, :intake, :date
    add_column :studentdisciplinesearches, :intake, :integer
  end
end
