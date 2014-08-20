class AddColumnToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :remark, :string
  end
end
