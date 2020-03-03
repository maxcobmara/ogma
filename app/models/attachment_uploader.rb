class AttachmentUploader < ActiveRecord::Base 
  #---------------------AttachFile------------------------------------------------------------------------
   has_attached_file :data,
                      :url => "/assets/conversations/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/conversations/:id/:style/:basename.:extension"
   validates_attachment_content_type :data, 
                          :content_type => ['application/pdf', 'application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.oasis.opendocument.text', 'application/msexcel','application/vnd.oasis.opendocument.spreadsheet','application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'image/png', 'image/jpeg', 'image/gif'],
                          :storage => :file_system,
                          :message => "Invalid File Format" 
   validates_attachment_size :data, :less_than => 5.megabytes 
end

# == Schema Information
#
# Table name: attachment_uploaders
#
#  created_at         :datetime
#  data_content_type  :string(255)
#  data_file_name     :string(255)
#  data_file_size     :integer
#  data_updated_at    :datetime
#  id                 :integer          not null, primary key
#  msgnotification_id :integer
#  updated_at         :datetime
#
