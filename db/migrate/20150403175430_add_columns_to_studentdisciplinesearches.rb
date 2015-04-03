class AddColumnsToStudentdisciplinesearches < ActiveRecord::Migration
  def change
    add_column :studentdisciplinesearches, :icno, :string
  end
end
