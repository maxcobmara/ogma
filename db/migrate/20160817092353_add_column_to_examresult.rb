class AddColumnToExamresult < ActiveRecord::Migration
  def change
    add_column :examresults, :intake_id, :integer
  end
end
