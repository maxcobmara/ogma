class AddColumnToAssetLoans < ActiveRecord::Migration
  def change
    add_column :asset_loans, :driver_id, :integer
    add_column :asset_loans, :is_endorsed, :boolean
    add_column :asset_loans, :endorsed_date, :date
  end
end
