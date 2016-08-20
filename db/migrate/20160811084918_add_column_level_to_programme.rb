class AddColumnLevelToProgramme < ActiveRecord::Migration
  def change
    add_column :programmes, :level, :string
  end
end
