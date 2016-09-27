class CreateBookingfacilities < ActiveRecord::Migration
  def change
    create_table :bookingfacilities do |t|
      t.integer :location_id
      t.integer :staff_id
      t.date :request_date
      t.datetime :start_date
      t.datetime :end_date
      t.integer :approver_id
      t.boolean :approval
      t.date :approval_date
      t.string :remark
      t.boolean :approval2
      t.date :approval_date2
      t.string :remark2
      t.integer :college_id
      t.text :data

      t.timestamps
    end
  end
end
