class Document < ActiveRecord::Base
# has_many :cofiles, :foreign_key => 'document_id'
#belongs_to :documents, :foreign_key => 'staff_id'
# has_one :title

validates_presence_of :serialno, :refno, :category, :title, :from, :stafffiled_id#,:letterdt, :letterxdt, :sender,

has_and_belongs_to_many   :staffs, :join_table => :documents_staffs   #5Apr2013

belongs_to :stafffilled,  :class_name => 'Staff', :foreign_key => 'stafffiled_id'
belongs_to :preparedby,   :class_name => 'Staff', :foreign_key => 'prepared_by'
belongs_to :cc1staff,     :class_name => 'Staff', :foreign_key => 'cc1staff_id' 
belongs_to :cofile,       :foreign_key => 'file_id'

has_many :asset_disposals
has_many :asset_losses
#has_many :travel_requests,   :dependent => :nullify #ref:gmail-sept15,2012-Checking for broken association - refer document.rb (line 17)

before_save :set_actionstaff2_to_blank_if_close_is_selected

  #5Apr2013
  def self.set_serialno(id)
    if id
      Document.find(id).serialno
    else
      (Document.last.id)+1
    end
  end

  def set_actionstaff2_to_blank_if_close_is_selected
    if cc1closed == true
      self.cc2staff_id = nil
    end
  end


  def filedocer
    suid = file_id
    #Cofile.find(:all, :select => "name", :conditions => {:id => suid}).map(&:name)
    Cofile.where(id: suid).pluck(:name)#:all, :select => "name", :conditions => {}).map(&:name)
  end
  
  #<% @admin = User.current_user.roles.map(&:id).include?(2) %>
  
  def owner_ids
    a = Array.new
    #a.push(stafffiled_id, cc1staff_id, cc2staff_id)
    @admin = User.current_user.roles.map(&:id).include?(2) 
    a.push(stafffiled_id,prepared_by)#,cc1staff_id)
    if @admin == true 
        a.push(stafffiled_id,prepared_by,User.current_user.staff_id)
    end
    a
  end




 def self.find_main
    Document.find(:all, :condition => ['document_id IS NULL'])
  end
  
  def self.find_main
      Cofile.find(:all, :condition => ['cofile_id IS NULL'])
  end


#-------------------------Search---------------------------------------------------  

#---------------------AttachFile------------------------------------------------------------------------
 has_attached_file :data,
                    :url => "/assets/documents/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/documents/:id/:style/:basename.:extension"

 validates_attachment_content_type :data, 
                                   :content_type => ['application/pdf','application/txt', 'application/msword',
                                                     'application/msexcel','image/png','image/jpeg','text/plain',
                                                      'application/vnd.openxmlformats-officedocument.wordprocessingml.document'],
                                   :storage => :file_system,
                                   :message => "Invalid File Format" 
                                   
 validates_attachment_size :data, :less_than => 5.megabytes
 
 #---------------------AttachFile-for circulation:action------------------------------------------------------
  has_attached_file :dataaction,
                     :url => "/assets/documents/:id/:style/:basename.:extension",
                     :path => ":rails_root/public/assets/documents/:id/:style/:basename.:extension"
  #validates_attachment_content_type :data, 
                         #:content_type => ['application/pdf', 'application/msword','application/msexcel','image/png','text/plain'],
                         #:storage => :file_system,
                         #:message => "Invalid File Format" 
  validates_attachment_size :dataaction, :less_than => 5.megabytes



  
  def stafffiled_details 
    stafffilled.mykad_with_staff_name
  end
    
  def cc1staff_details 
    check_kin_blank {cc1staff.mykad_with_staff_name}
  end
    
  def file_details 
    cofile.file_no_and_name
  end
  
  def doc_details
    "#{refno}"+" | "+"#{title.capitalize}"
  end
  
  def doc_details_date 
    "#{refno}"+" : "+"#{title.capitalize}"+" - "+"#{letterdt}"
  end
    

  def to_name
  	recipient_qty = staffs.count
  	staff_names = []
  	count = 0
  	for staff in staffs 
  		count+=1
  		if count != recipient_qty
  			staff_names << staff.name+"," 
  		else
  			staff_names << staff.name
  		end
  	end 
  	return staff_names [0]
  end


  def to_name=(name)
	  self.staffs = Staff.find_by_name(name) unless name.blank?
  end


  
end

# == Schema Information
#
# Table name: documents
#
#  category                :integer
#  cc1action               :string(255)
#  cc1actiondate           :date
#  cc1closed               :boolean
#  cc1date                 :date
#  cc1remarks              :text
#  cc1staff_id             :integer
#  cc2action               :string(255)
#  cc2closed               :boolean
#  cc2date                 :date
#  cc2remarks              :text
#  cc2staff_id             :integer
#  cctype_id               :integer
#  closed                  :boolean
#  created_at              :datetime
#  data_content_type       :string(255)
#  data_file_name          :string(255)
#  data_file_size          :integer
#  data_updated_at         :datetime
#  dataaction_content_type :string(255)
#  dataaction_file_name    :string(255)
#  dataaction_file_size    :integer
#  dataaction_updated_at   :datetime
#  file_id                 :integer
#  from                    :string(255)
#  id                      :integer          not null, primary key
#  letterdt                :date
#  letterxdt               :date
#  otherinfo               :text
#  prepared_by             :integer
#  refno                   :string(255)
#  sender                  :string(255)
#  serialno                :string(255)
#  stafffiled_id           :integer
#  title                   :string(255)
#  updated_at              :datetime
#
