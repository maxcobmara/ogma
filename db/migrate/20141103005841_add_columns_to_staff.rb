class AddColumnsToStaff < ActiveRecord::Migration
  def change
    add_column :staffs, :allowance, :decimal
    add_column :staffs, :salary_no, :string
  end
end
