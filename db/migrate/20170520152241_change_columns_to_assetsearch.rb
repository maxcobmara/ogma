class ChangeColumnsToAssetsearch < ActiveRecord::Migration
  def change
    remove_column :assetsearches, :disposalreport, :string
    add_column :assetsearches, :disposalreport_start, :date
    remove_column :assetsearches, :disposalreport2, :string
    add_column :assetsearches, :disposalreport_end, :date
    
    add_column :assetsearches, :examine_start, :date
    add_column :assetsearches, :examine_end, :date
  end
end
