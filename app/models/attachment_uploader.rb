class AttachmentUploader < ActiveRecord::Base 
  #---------------------AttachFile------------------------------------------------------------------------
   has_attached_file :data,
                      :url => "/assets/lesson_plans/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/lesson_plans/:id/:style/:basename.:extension"
   validates_attachment_content_type :data, 
                          :content_type => ['application/pdf', 'application/msword','application/msexcel','image/png','text/plain'],
                          :storage => :file_system,
                          :message => "Invalid File Format" 
   validates_attachment_size :data, :less_than => 5.megabytes 
end