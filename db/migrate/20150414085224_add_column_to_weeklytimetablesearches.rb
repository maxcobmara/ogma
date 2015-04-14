class AddColumnToWeeklytimetablesearches < ActiveRecord::Migration
  def change
    add_column :weeklytimetablesearches, :validintake, :integer
  end
end
