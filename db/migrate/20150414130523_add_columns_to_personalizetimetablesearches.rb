class AddColumnsToPersonalizetimetablesearches < ActiveRecord::Migration
  def change
    add_column :personalizetimetablesearches, :startdate, :date
    add_column :personalizetimetablesearches, :enddate, :date
  end
end
