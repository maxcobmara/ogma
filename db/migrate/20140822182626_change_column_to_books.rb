class ChangeColumnToBooks < ActiveRecord::Migration
  def self.up
    remove_column :books, :finance_source
    add_column :books, :finance_source, :string
  end

  def self.down
    remove_column :books, :finance_source
    add_column :books, :finance_source, :decimal
  end
end
