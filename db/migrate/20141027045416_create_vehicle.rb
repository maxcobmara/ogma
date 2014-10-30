class CreateVehicle < ActiveRecord::Migration
  def self.up
    create_table :vehicles do |t|
      t.string :type_model
      t.string :reg_no
      t.integer :cylinder_capacity
      t.integer :staff_id
    end
  end
  def self.down
    drop_table :vehicles
  end
end
