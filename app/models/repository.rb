class Repository < ActiveRecord::Base
  belongs_to :creator, class_name: 'Staff', foreign_key: 'staff_id'
  
  before_validation :set_upload_when_present
  after_save :remove_cache_upload
  
  serialize :data, Hash
  
  has_attached_file :uploaded,
                    :url => "/assets/uploads/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/uploads/:id/:style/:basename.:extension" #,
                  #  :styles => { :original => "250x300>", :thumbnail => "50x60" } #default size of uploaded image
  validates_attachment_size :uploaded, :less_than => 50.megabytes
  validates_attachment_content_type :uploaded, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]
  
  validates :category, :title, :uploaded, :staff_id, presence: true, :if => :data_not_present?
  validates :document_type, :document_subtype, :title, :staff_id, :vessel_class, presence: true, :if => :data_is_present?  #:publish_date,  :uploaded,
  
  # NOTE - 20Apr2017 - workaround - to retrieve missing uploaded file when validation fails!  - start ####
  attr_accessor :uploadcache, :vessel_select, :ticker
  
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
  
  def classification=(value)
    data[:classification]=value
  end
  
  def classification
    data[:classification]
  end
  
  def code=(value)
    data[:code]=value
  end
  
  def code
    data[:code]
  end
  
  def vessel_class=(value)
    data[:vessel_class]=value
  end
  
  def vessel_class
    data[:vessel_class]
  end
  
  #Ransack - may also use 
  #define scope
  def self.vessel_search(query)
    ids=[]
    Repository.digital_library.each do |repo|
      unless repo.vessel.blank?
        if repo.render_vessel.downcase.include?(query.downcase)
          ids << repo.id
        end
      else
        Repository.vessel_list2.each do |vesselclass, vessels| 
	  ##
	  if repo.render_vessel_class==vesselclass
	    vessels.each do |vessel|
	      if vessel.downcase.include?(query.downcase) && 
	        ids << repo.id
	      end
	    end
	  end
	  ##
        end
      end
    end
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
  
  def self.classification_search(query)
    ids=[]
    Repository.digital_library.each{ |repo| ids << repo.id if repo.classification==query}
    where(id: ids)
  end

  def self.status_search(query)
    ids=[]
    loaned=Librarytransaction.marine_loaned_serial
    Repository.digital_library.each do |repo| 
      if query=="1"                                                               #available
        ids << repo.id  if loaned.include?(repo.code)==false
      elsif query=="2"                                                          #on loan
       ids << repo.id  if loaned.include?(repo.code)==true
      end
    end
    where(id: ids)
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:vessel_search, :refno_search, :publish_date_search, :location_search, :document_type_search, :document_subtype_search, :classification_search, :status_search]
  end  
  
  def self.document
   [[I18n.t('repositories.book'), '1'],
     [I18n.t('repositories.drawing'), '2'],
     [I18n.t('repositories.test_trials'), '3']
    ]
  end
  
  def self.subdocument
    [[I18n.t('repositories.propulsion'), '1'],
      [I18n.t('repositories.auxiliaries'), '9'],
     [I18n.t('repositories.electrical'), '2'],
     [I18n.t('repositories.weapon'), '3'],
     [I18n.t('repositories.navigation'), '4'],
     [I18n.t('repositories.communication'), '5'],
     [I18n.t('repositories.hull_fitting'), '6'],
     [I18n.t('repositories.life_equipment'), '7'],
     [I18n.t('repositories.damage_safety'), '8']
     ]
  end
  
  def self.document_classification
    [[I18n.t('repositories.restricted'), '1'],
     [I18n.t('repositories.confidential'), '2'],
     [I18n.t('repositories.secret'), '3']
     ]
  end
  
  def self.vessel_classes
    [['Frigate', '1'],
     ['Corvette', '2'],
     ['Patrol Vessel', '3'],
     ['Multi Purpose Support Ship', '4'],
     ['Others', '5']]
  end
 
  def self.vessel_list
    [
     ['Frigate', [[I18n.t('select'),''], ['KD Jebat', '1'], ['KD Lekiu', '2']]], 
     ['Corvette',[[I18n.t('select'),''], ['KD Kasturi', '3'], ['KD Lekir', '4']]], 
     ['Patrol Vessel', [[I18n.t('select'),''], ['KD Pahang', '5'], ['KD Kelantan', '6'], ['KD Selangor', '7'], ['KD Terengganu', '8'],['KD Kedah', '9'], ['KD Perak', '10']]], 
     ['Multi Purpose Support Ship', [[I18n.t('select'),''], ['KD Mahawangsa', '11']]], 
     ['Others', [[I18n.t('select'),''], ['KLD Tunas Samudera', '12'],['KD Perantau', '13']]]
     ]
  end
  
  def self.vessel_list2
    [
     ['Frigate', ['KD Jebat', 'KD Lekiu']], 
     ['Corvette',['KD Kasturi', 'KD Lekir']], 
     ['Patrol Vessel', ['KD Pahang', 'KD Kelantan', 'KD Selangor', 'KD Terengganu', 'KD Kedah', 'KD Perak']], 
     ['Multi Purpose Support Ship', ['KD Mahawangsa']], 
     ['Others', ['KLD Tunas Samudera', 'KD Perantau']]
     ]
  end
  
#   def self.vessel_list
#     [['KD Jebat', '1'], 
#      ['KD Lekiu', '2'], 
#      ['----------------', ''],
#      ['KD Kasturi', '3'], 
#      ['KD Lekir', '4'], 
#      ['KD Pahang', '5'], 
#      ['KD Kelantan', '6'], 
#      ['KD Selangor', '7'], 
#      ['KD Terengganu', '8'], 
#      ['-----------------------', ''],
#      ['KD Kedah', '9'], 
#      ['KD Perak', '10'], 
#      ['-------------------------', ''],
#      ['KD Mahawangsa', '11'], 
#      ['-------------------------', ''],
#      ['KLD Tunas Samudera', '12'],
#      ['KD Perantau', '13']
#      ]
#   end
  
  def render_document
    (Repository.document.find_all{|disp, value| value == document_type }).map {|disp, value| disp}[0]
  end
  
  def render_subdocument
    (Repository.subdocument.find_all{|disp, value| value == document_subtype }).map {|disp, value| disp}[0]
  end
  
  def render_classification
    (Repository.document_classification.find_all{|disp, value|value==classification}).map {|disp, value| disp}[0]
  end
  
  def render_vessel_class
    (Repository.vessel_classes.find_all{|disp, value|value==vessel_class}).map {|disp, value| disp}[0]
  end
  
  def render_vessel 
    (Repository.vessel_list[(vessel_class.to_i)-1][1].find_all{|d,v|v==vessel}).map{|d,v|d}[0]
    #(Repository.vessel_list.find_all {|disp, value| value==vessel}).map {|disp, value| disp}[0]
  end
    
#   def self.doctype_per_vessel
#     ab=[]
#     Repository.digital_library.group_by(&:vessel).each do |k,v|
#       a=[[I18n.t('select'), ""]]
#        v.each do |y|
# 	 a << [y.render_document, y.document_type]
#        end
#       ab << [k, a.uniq]
#     end
#     ab
#   end
  
  def self.vessel_names
    ['KD Jebat', 'KD Lekiu', 'KD Kasturi', 'KD Lekir', 'KD Pahang', 'KD Kelantan', 'KD Selangor', 'KD Terengganu', 'KD Kedah', 'KD Perak', 'KD Mahawangsa', 'KLD Tunas Samudera', 'KD Perantau']
  end
  
  def self.doctype_per_vessel
    ab=[]
    Repository.digital_library.group_by{|x|x.vessel_class}.sort.each do |vessel_class, repositories|
      for a_vessel in Repository.vessel_names
        a=[[I18n.t('select'), ""]]
        for repository in repositories
          unless repository.vessel.blank? #specific
            a << [repository.render_document, repository.document_type] if repository.render_vessel==a_vessel
          else #master
            a << [repository.render_document, repository.document_type]
          end
        end
        ab << [a_vessel, a.uniq]
      end
    end
    ab
  end
  
  def self.docsubtype_per_doctype
    ab=[]
    Repository.digital_library.group_by{|x|x.vessel_class}.sort.each do |vessel_class, repositories|
      for a_vessel in Repository.vessel_names
        repositories.group_by(&:document_type).each do |dt, rs|
          a=[[I18n.t('select'), ""]]
          for repository in rs
            unless repository.vessel.blank? #specific
              a << [repository.render_subdocument, repository.document_subtype] if repository.render_vessel==a_vessel && dt==repository.document_type
            else #master
              a << [repository.render_subdocument, repository.document_subtype] && dt==repository.document_type
            end
          end
          ab << [a_vessel+": "+((Repository.document.find_all{|disp, value| value == dt }).map {|disp, value| disp}[0]), a.uniq]
        end 
      end
    end
    ab
  end
  
#   def self.docsubtype_per_doctype
#     ab=[]
#     Repository.digital_library.group_by(&:vessel).each do |k,v|
#       v.group_by(&:document_type).each do |dt, rs|
# 	  a=[[I18n.t('select'), ""]]
# 	  rs.each do |r|
#             a << [r.render_subdocument, r.document_subtype]
#           end
#           ab << [k+": "+((Repository.document.find_all{|disp, value| value == dt }).map {|disp, value| disp}[0]), a.uniq]
#       end
#     end
#     ab
#   end
  
end
