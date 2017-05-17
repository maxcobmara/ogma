class AddColumnToAssetsearch < ActiveRecord::Migration
  def change
    add_column :assetsearches, :search_type, :integer
  end
end
