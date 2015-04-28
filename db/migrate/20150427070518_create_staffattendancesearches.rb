class CreateStaffattendancesearches < ActiveRecord::Migration
  def change
    create_table :staffattendancesearches do |t|
      t.string :department
      t.integer :thumb_id
      t.datetime :logged_at
      t.timestamps
    end
  end
end
