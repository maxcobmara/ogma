class AddColumnToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :current_salary, :decimal
  end
end
