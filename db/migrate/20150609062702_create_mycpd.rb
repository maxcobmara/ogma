class CreateMycpd < ActiveRecord::Migration
  def change
    create_table :mycpds do |t|
      t.date :cpd_year
      t.decimal :cpd_value
      t.integer :staff_id
    end
  end
end
