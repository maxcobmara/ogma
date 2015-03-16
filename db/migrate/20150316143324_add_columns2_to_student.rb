class AddColumns2ToStudent < ActiveRecord::Migration
  def change
    add_column :students, :sstatus_remark, :string
  end
end
