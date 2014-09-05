class AddColumnToBook < ActiveRecord::Migration
  def self.up
    add_column :books, :finance_source, :decimal
  end

  def self.down
    remove_column :books, :finance_source
  end
end
