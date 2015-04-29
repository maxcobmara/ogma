class CreatePtdosearches < ActiveRecord::Migration
  def change
    create_table :ptdosearches do |t|
      t.integer :attended_courses
      t.string :department
      t.string :staff_name
      t.integer :staff_id
      t.string :icno
      t.date :schedulestart_start 
      t.date :schedulestart_end
    end
  end
end
