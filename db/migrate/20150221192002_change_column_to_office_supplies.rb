class ChangeColumnToOfficeSupplies < ActiveRecord::Migration
  def self.up
    remove_column :stationeries, :maxquantity
    remove_column :stationeries, :minquantity
    add_column :stationeries, :maxquantity, :integer
    add_column :stationeries, :minquantity, :integer
    
    remove_column :stationery_uses, :quantity
    add_column :stationery_uses, :quantity, :integer
    remove_column :stationery_adds, :quantity
    add_column :stationery_adds, :quantity, :integer
  end

  def self.down
    remove_column :stationeries, :maxquantity
    remove_column :stationeries, :minquantity
    add_column :stationeries, :maxquantity, :decimal
    add_column :stationeries, :minquantity, :decimal
    
    remove_column :stationery_uses, :quantity
    add_column :stationery_uses, :quantity, :decimal
    remove_column :stationery_adds, :quantity
    add_column :stationery_adds, :quantity, :decimal
  end
end
