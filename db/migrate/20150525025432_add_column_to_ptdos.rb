class AddColumnToPtdos < ActiveRecord::Migration
  def change
    add_column :ptdos, :payment, :integer
    add_column :ptdos, :remark, :text
  end
end
