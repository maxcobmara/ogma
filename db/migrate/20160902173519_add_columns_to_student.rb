class AddColumnsToStudent < ActiveRecord::Migration
  def change
    add_column :students, :religion, :integer
    add_column :students, :birthplace, :integer
  end
end
