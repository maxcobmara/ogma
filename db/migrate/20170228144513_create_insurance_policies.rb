class CreateInsurancePolicies < ActiveRecord::Migration
  def change
    create_table :insurance_policies do |t|
      t.integer :insurance_type
      t.integer :company_id
      t.string :policy_no
      t.integer :college_id
      t.text :data

      t.timestamps
    end
  end
end
