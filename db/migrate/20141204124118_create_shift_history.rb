class CreateShiftHistory < ActiveRecord::Migration
  def change
    create_table :shift_histories do |t|
      t.integer :staff_id
      t.integer :shift_id
      t.date :deactivate_date
      t.timestamps
    end
  end
end
