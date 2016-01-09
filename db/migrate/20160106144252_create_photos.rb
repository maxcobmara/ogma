class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :caption
      t.string   :diagram_file_name
      t.string   :diagram_content_type
      t.integer  :diagram_file_size
      t.datetime :diagram_updated_at
      t.timestamps
    end
  end
end
