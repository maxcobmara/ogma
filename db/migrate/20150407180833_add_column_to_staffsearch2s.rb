class AddColumnToStaffsearch2s < ActiveRecord::Migration
  def change
    add_column :staffsearch2s, :position2, :integer
    add_column :staffsearch2s, :position3, :integer
  end
end
