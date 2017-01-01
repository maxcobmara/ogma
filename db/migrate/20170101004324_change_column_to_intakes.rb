class ChangeColumnToIntakes < ActiveRecord::Migration
  def change
    remove_column :intakes, :data, :string
    add_column :intakes, :data, :text
  end
end
