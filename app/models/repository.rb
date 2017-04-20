class Repository < ActiveRecord::Base
  belongs_to :creator, class_name: 'Staff', foreign_key: 'staff_id'
  
  before_validation :set_upload_when_present
  after_save :remove_cache_upload
  
  serialize :data, Hash
  
  has_attached_file :uploaded,
                    :url => "/assets/uploads/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/uploads/:id/:style/:basename.:extension" #,
                  #  :styles => { :original => "250x300>", :thumbnail => "50x60" } #default size of uploaded image
  validates_attachment_size :uploaded, :less_than => 25.megabytes
  validates_attachment_content_type :uploaded, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  
  validates :category, :title, :uploaded, :staff_id, presence: true, :if => :data_not_present?
  validates :vessel, :document_type, :document_subtype, :title, :uploaded, :staff_id, presence: true, :if => :data_is_present?  #:publish_date, 
  
  # NOTE - 20Apr2017 - workaround - to retrieve missing uploaded file when validation fails!  - start ####
  attr_accessor :uploadcache
  
  def set_upload_when_present
    unless uploadcache.blank?
      self.uploaded=AttachmentUploader.find(uploadcache.to_i).data if uploaded.blank?
    end
  end
  
  def remove_cache_upload
    unless uploadcache.blank?
      cached=AttachmentUploader.find(uploadcache.to_i)
      cached.destroy!
    end
  end
  ######## - workaround ends here - NOTE - to refer above (line 4 & 5), model/attachment_uploader.rb, controller & form.
  
  def render_category
    (Repository::CATEGORY.find_all{|disp, value| value == category }).map {|disp, value| disp}[0]
  end
  
  CATEGORY=[
                # Displayed               #Stored in db
            ['KKM', 1],
            ['KS', 2],
            ['WP', 3],
            ['TBL', 4],
            ['RAN', 5],
            ['Others', 6]
            ]
  
  def data_not_present?
    data.blank? == true
  end
  
  def data_is_present?
    data.blank? == false
  end
  
  #digital library parts

  scope :digital_library, -> { where.not(data: nil)}
  
  def vessel=(value)
    data[:vessel] = value
  end
  
  def vessel
    data[:vessel]
  end
  
  def document_type=(value)
    data[:document_type] = value
  end
  
  def document_type
    data[:document_type]
  end
  
  def document_subtype=(value)
    data[:document_subtype] = value
  end
  
  def document_subtype
    data[:document_subtype]
  end
  
  def refno=(value)
    data[:refno] = value
  end
  
  def refno
    data[:refno]
  end
  
  def publish_date=(value)
    data[:publish_date] = value
  end
  
  def publish_date
    data[:publish_date]
  end
  
  def total_pages=(value)
    data[:total_pages] = value
  end
  
  def total_pages
    data[:total_pages]
  end
  
  def copies=(value)
    data[:copies] = value
  end
  
  def copies
    data[:copies]
  end
  
  def location=(value)
    data[:location] = value
  end
  
  def location
    data[:location]
  end
  
  def remark=(value)
    data[:remark]=value
  end
  
  def remark
    data[:remark]
  end
  
  #Ransack - may also use 
  #define scope
  def self.vessel_search(query)
    ids=[]
    Repository.digital_library.each{ |repo|  ids << repo.id if repo.vessel.downcase.include?(query.downcase)}
    where(id: ids)
  end
  
  def self.refno_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.refno.downcase.include?(query.downcase)}
    where(id: ids)
  end
  
  def self.publish_date_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.publish_date==query}
    where(id: ids)
  end
  
  def self.location_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.location.downcase.include?(query.downcase)}
    where(id: ids)
  end
  
  def self.document_type_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.document_type==query}
    where(id: ids)
  end
  
  def self.document_subtype_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.document_subtype==query}
    where(id: ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:vessel_search, :refno_search, :publish_date_search, :location_search, :document_type_search, :document_subtype_search]
  end  
  
  def self.document
   [[I18n.t('repositories.book'), '1'],
     [I18n.t('repositories.drawing'), '2'],
     [I18n.t('repositories.test_trials'), '3'],
     [I18n.t('repositories.others'), '4']
    ]
  end
  
  def self.subdocument
    [[I18n.t('repositories.propulsion'), '1'],
     [I18n.t('repositories.electrical'), '2'],
     [I18n.t('repositories.weapon'), '3'],
     [I18n.t('repositories.navigation'), '4'],
     [I18n.t('repositories.communication'), '5'],
     [I18n.t('repositories.hull_fitting'), '6'],
     [I18n.t('repositories.life_equipment'), '7'],
     [I18n.t('repositories.damage_safety'), '8'],
     [I18n.t('repositories.auxiliaries'), '9']
     ]
  end
  
  def render_document
    (Repository.document.find_all{|disp, value| value == document_type }).map {|disp, value| disp}[0]
  end
  
  def render_subdocument
    (Repository.subdocument.find_all{|disp, value| value == document_subtype }).map {|disp, value| disp}[0]
  end
  
  def self.doctype_per_vessel
    ab=[]
    Repository.digital_library.group_by(&:vessel).each do |k,v|
      a=[[I18n.t('select'), ""]]
       v.each do |y|
	 a << [y.render_document, y.document_type]
       end
      ab << [k, a.uniq]
    end
    ab
  end
  
  def self.docsubtype_per_doctype
    ab=[]
    Repository.digital_library.group_by(&:vessel).each do |k,v|
      v.group_by(&:document_type).each do |dt, rs|
	  a=[[I18n.t('select'), ""]]
	  rs.each do |r|
            a << [r.render_subdocument, r.document_subtype]
          end
          ab << [k+": "+((Repository.document.find_all{|disp, value| value == dt }).map {|disp, value| disp}[0]), a.uniq]
      end
    end
    ab
  end
  
end
