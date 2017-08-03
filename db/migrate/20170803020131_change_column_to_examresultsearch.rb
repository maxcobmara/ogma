class ChangeColumnToExamresultsearch < ActiveRecord::Migration
  def change
    remove_column :examresultsearches, :programme_id, :integer
    add_column :examresultsearches, :intake_id, :integer
  end
end
