class AddColumnsToPtschedules < ActiveRecord::Migration
  def change
    add_column :ptschedules, :payment, :integer
    add_column :ptschedules, :remark, :text
  end
end
