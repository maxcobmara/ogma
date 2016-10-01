class CreateMentors < ActiveRecord::Migration
  def change
    create_table :mentors do |t|
      t.integer :staff_id
      t.date :mentor_date
      t.string :remark
      t.integer :college_id
      t.text :data

      t.timestamps
    end
  end
end
