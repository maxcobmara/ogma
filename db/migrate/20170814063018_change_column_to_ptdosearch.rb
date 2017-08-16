class ChangeColumnToPtdosearch < ActiveRecord::Migration
  def change
    remove_column :ptdosearches, :attended_courses, :integer
    add_column :ptdosearches, :searchby_post_id, :integer
  end
end
