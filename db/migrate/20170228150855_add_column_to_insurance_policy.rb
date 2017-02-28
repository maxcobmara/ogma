class AddColumnToInsurancePolicy < ActiveRecord::Migration
  def change
    add_column :insurance_policies, :staff_id, :integer
  end
end
