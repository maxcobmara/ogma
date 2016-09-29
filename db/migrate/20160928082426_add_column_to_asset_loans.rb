class AddColumnToAssetLoans < ActiveRecord::Migration
  def change
    add_column :asset_loans, :driver_id, :integer
    add_column :asset_loans, :is_endorsed, :boolean
    add_column :asset_loans, :endorsed_date, :date
    add_column :asset_loans, :endorsed_note, :string
    add_column :asset_loans, :approved_note, :string
  end
end
