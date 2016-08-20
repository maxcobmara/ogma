class AddColumnRankToStaffs < ActiveRecord::Migration
  def change
    add_column :staffs, :rank_id, :integer
  end
end
