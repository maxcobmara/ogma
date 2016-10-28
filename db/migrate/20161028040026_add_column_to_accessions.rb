class AddColumnToAccessions < ActiveRecord::Migration
  def change
    add_column :accessions, :status, :integer
  end
end
