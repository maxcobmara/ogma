class AddColumnToTenant < ActiveRecord::Migration
  def change
    add_column :tenants, :visitor_id, :integer
  end
end
