class AddColumnsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :position, :string
    add_column :students, :department, :string
    add_column :students, :vehicle_no, :string
    add_column :students, :vehicle_type, :string
  end
end
