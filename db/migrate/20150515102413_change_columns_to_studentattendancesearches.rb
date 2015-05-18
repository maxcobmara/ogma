class ChangeColumnsToStudentattendancesearches < ActiveRecord::Migration
  def change
    remove_column :studentattendancesearches, :intake_id
    add_column :studentattendancesearches, :intake_id, :integer
  end
end
