class ChangeColumnToAttachmentUploader < ActiveRecord::Migration
  def change
    remove_column :attachment_uploaders, :data, :string
    add_column :attachment_uploaders, :data2, :text
  end
end
