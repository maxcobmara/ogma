class AddColumnToDocument < ActiveRecord::Migration
  def change
    add_column :documents, :distribution_type, :integer
  end
end
