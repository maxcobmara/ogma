class ChangeColumnDurationToProgramme < ActiveRecord::Migration
  def self.up
    remove_column :programmes, :duration
    add_column :programmes, :duration, :decimal
  end

  def self.down
    remove_column :programmes, :duration
    add_column :programmes, :duration, :integer
  end
end
