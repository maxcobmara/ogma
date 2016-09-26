class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :title
      t.integer :staff_id
      t.integer :category
      t.string :uploaded_file_name
      t.string :uploaded_content_type
      t.integer :uploaded_file_size
      t.datetime :uploaded_updated_at
      t.integer :college_id
      t.text :data

      t.timestamps
    end
  end
end
