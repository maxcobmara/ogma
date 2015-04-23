class AddColumnToExamsearches < ActiveRecord::Migration
  def change
    add_column :examsearches, :valid_papertype, :integer
  end
end
