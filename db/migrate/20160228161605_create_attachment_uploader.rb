class CreateAttachmentUploader < ActiveRecord::Migration
  def change
    create_table :attachment_uploaders do |t|
      t.integer :msgnotification_id
      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size
      t.datetime :data_updated_at
      t.timestamps
    end
  end
end
