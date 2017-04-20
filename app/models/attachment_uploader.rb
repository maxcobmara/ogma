class AttachmentUploader < ActiveRecord::Base 
  
  serialize :data2, Hash
 
  #---------------------AttachFile------------------------------------------------------------------------
   has_attached_file :data,
                      :url => "/assets/conversations/:id/:style/:basename.:extension",
                      :path => ":rails_root/public/assets/conversations/:id/:style/:basename.:extension"
   validates_attachment_content_type :data, 
                          :content_type => ['application/pdf', 'application/msword','application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.oasis.opendocument.text', 'application/msexcel','application/vnd.oasis.opendocument.spreadsheet','application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'image/png', 'image/jpeg', 'image/gif'],
                          :storage => :file_system,
                          :message => "Invalid File Format" 
   validates_attachment_size :data, :less_than => 25.megabytes 
   
  #Usage 1 - refer Conversation : conversations_controller
   
  #Usage 2 - NOTE - 20Apr2017 - workaround - to retrieve missing uploaded file when validation fails!  - start #### 
  def upload_for=(value)
    data2[:upload_for] = value
  end
  
  def upload_for
    data2[:upload_for]
  end
  ######## - workaround ends here - NOTE - to refer repositories_controller.rb, model/repository.rb & repositories/_form too#
 
end