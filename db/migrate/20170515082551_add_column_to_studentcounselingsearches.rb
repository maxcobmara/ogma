class AddColumnToStudentcounselingsearches < ActiveRecord::Migration
  def change
    add_column :studentcounselingsearches, :icno, :string
  end
end
