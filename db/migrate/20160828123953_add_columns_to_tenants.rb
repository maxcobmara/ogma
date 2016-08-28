class AddColumnsToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :total_keys, :integer
    add_column :tenants, :deposit, :decimal
    add_column :tenants, :meal_requirement, :boolean
  end
end
