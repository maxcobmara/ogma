class ChangeColumnToAccession < ActiveRecord::Migration
  def change
    remove_column :accessions, :data, :string
    add_column :accessions, :data, :text
  end
end
