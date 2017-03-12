class AddColumnToVisitor < ActiveRecord::Migration
  def change
    add_column :visitors, :position, :string
  end
end
