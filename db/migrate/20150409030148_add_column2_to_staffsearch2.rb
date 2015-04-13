class AddColumn2ToStaffsearch2 < ActiveRecord::Migration
  def change
    add_column :staffsearch2s, :blank_post, :integer
  end
end
