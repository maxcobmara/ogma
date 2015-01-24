class CreateCirculations < ActiveRecord::Migration
  def change
    create_table :circulations do |t|
      t.integer :document_id
      t.integer :staff_id
      t.date     :action_date
      t.string   :action_taken
      t.text     :action_remarks
      t.boolean  :action_closed
      t.string   :action_file_name
      t.string   :action_content_type
      t.integer  :action_file_size
      t.datetime :action_updated_at
    end
  end
end
