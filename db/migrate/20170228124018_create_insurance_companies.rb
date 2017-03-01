class CreateInsuranceCompanies < ActiveRecord::Migration
  def change
    create_table :insurance_companies do |t|
      t.string :short_name
      t.string :long_name
      t.boolean :active
      t.integer :college_id
      t.text :data

      t.timestamps
    end
  end
end
