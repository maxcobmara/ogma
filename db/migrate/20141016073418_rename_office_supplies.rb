class RenameOfficeSupplies < ActiveRecord::Migration
  def change
    rename_table :usesupplies, :stationery_uses;
    rename_table :addsuppliers, :stationery_adds;
    rename_column :stationery_uses, :supplier_id, :stationery_id;
    rename_column :stationery_adds, :supplier_id, :stationery_id;
  end
end
