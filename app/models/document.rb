class Document < ActiveRecord::Base

  before_save :set_actionstaff2_to_blank_if_close_is_selected

  has_many :asset_disposals
  has_many :asset_losses
  has_attached_file :data,
                     :url => "/assets/documents/:id/:style/:basename.:extension",
                     :path => ":rails_root/public/assets/documents/:id/:style/:basename.:extension"
  #has_and_belongs_to_many   :staffs, :join_table => :documents_staffs 
  has_many :circulations
  has_many :staffs, :through => :circulations#, :autosave => true
  accepts_nested_attributes_for :circulations, :allow_destroy => :true 

  belongs_to :stafffilled,  :class_name => 'Staff', :foreign_key => 'stafffiled_id'
  belongs_to :preparedby,   :class_name => 'Staff', :foreign_key => 'prepared_by'
  belongs_to :cc1staff,     :class_name => 'Staff', :foreign_key => 'cc1staff_id'          #amsas - Pengarah/Komandan Pusat Latihan/Komandan Akademi/Pengarah Kompetensi
  belongs_to :cofile,       :foreign_key => 'file_id'
  belongs_to :college, :foreign_key => 'college_id'

  validates_attachment_content_type :data, 
                                    :content_type => ['application/pdf','application/txt', 'application/msword',
                                                      'application/msexcel','image/png','image/jpeg','text/plain',
                                                       'application/vnd.openxmlformats-officedocument.wordprocessingml.document'],
                                    :storage => :file_system,
                                    :message => "Invalid File Format" 
                                
  validates_attachment_size :data, :less_than => 5.megabytes
  validates_presence_of :serialno, :refno, :category, :title, :from, :stafffiled_id#,:letterdt, :letterxdt, :sender,
  validates :cc1date, :circulations, presence: true, :if => :creator_action_is_closed?
  validates :cc2date, :circulations, presence: true, :if => :director_action_is_closed?
  
  attr_accessor :recipients 
 
  def creator_action_is_closed?
    college.code=='kskbjb' && cc1closed==true
  end
  
  def director_action_is_closed?
    college.code=='amsas' && cc2closed==true
  end

  def doc_details
     "#{refno}"+" : "+"#{title.capitalize}"
  end
  
  #5Apr2013
  def self.set_serialno(id)
    if id
      Document.find(id).serialno
    else
      if Document.all.count > 0
        (Document.last.id)+1
      else
        1
      end
    end
  end

  def set_actionstaff2_to_blank_if_close_is_selected
    if cc1closed == true
      self.cc2staff_id = nil
    end
  end


  def filedocer
    suid = file_id
    Cofile.where(id: suid).map(&:file_no_and_name)
  end
  
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

  def staffiled_list
    (User.joins(:roles).where('authname=? or authname=? or authname=? or authname=?', "e_filing", "documents_module_admin", "documents_module_user", "documents_module_member").pluck(:userable_id)+Array(stafffiled_id)).compact.uniq
    #add existing stafffiled_id just in case of changed of person in charge
  end
  
  def stafffiled_details 
    stafffilled.mykad_with_staff_name
  end
    
  def cc1staff_details 
    check_kin_blank {cc1staff.mykad_with_staff_name}
  end
    
  def file_details 
    cofile.file_no_and_name
  end
    
  def doc_details_date 
    doc_details+" - "+"#{letterdt}"
  end

  def self.sstaff2(search)
    if search
      document_ids=Circulation.where(staff_id: search).pluck(:document_id)
      where('stafffiled_id=? OR prepared_by=? OR cc1staff_id=? OR id IN(?)', search, search, search, document_ids)
    end
  end
  
  def saved_recipients_list
    #selected recipients - staff_ids (individual & group) - sample: [87, 117, 3, 57, 101]
    recipients_staffids=circulations.pluck(:staff_id) # staffs.pluck(:staff_id) - also can
            
    Group.all.each do |x|
      #group members (staff_id) in array - sample: [117, 3]
      group_staffids=User.where(id: x.listing).pluck(:userable_id)
      #a2.all? { |e| a1.include?(e) } #ref: http://stackoverflow.com/questions/7387937/ruby-rails-how-to-determine-if-one-array-contains-all-elements-of-another-array
      if group_staffids.all? {|e| recipients_staffids.include?(e)}
        recipients_staffids-=group_staffids
        recipients_staffids+=[group_staffids]
      end
    end

    recipients_staffids
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
