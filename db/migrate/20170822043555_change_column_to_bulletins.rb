class ChangeColumnToBulletins < ActiveRecord::Migration
  def change
    remove_column :bulletins, :data, :string
    add_column :bulletins, :data2, :string
  end
end
