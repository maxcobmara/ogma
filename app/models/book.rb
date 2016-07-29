class Book < ActiveRecord::Base
  
  before_save :update_tag_no, :extract_roman_into_size_pages
  
  belongs_to :staff, :foreign_key => 'receiver_id'
  belongs_to :addbook, :foreign_key => 'supplier_id'
  has_many  :accessions, :dependent => :destroy
  accepts_nested_attributes_for :accessions, :reject_if => lambda { |a| a[:accession_no].blank? }, :allow_destroy =>true
  
  attr_accessor :no_perolehan, :no_panggilan, :pengarang, :judul_utama, :edisi, :isbn_e, :bahasa, :tajuk_perkara, :imprint, :ms_indeks, :ms_bibliografi, :deskripsi_fizikal, :harga_rm, :sumber_kewangan, :lokasi, :catitan		#from excel (no_perolehan=accession_no, no_panggilan=classlcc)

  #-----------Attach Photo---------------
  has_attached_file :photo,
			      :url => "/assets/books/:id/:style/:basename.:extension",
			      :path => ":rails_root/public/assets/books/:id/:style/:basename.:extension",
                              :styles => { :original => "250x300>", :thumbnail => "50x60" }
  validates_attachment_size :photo, :less_than => 500.kilobytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  validates_presence_of :isbn, :title, :language
  validates_uniqueness_of :isbn
  
  def update_tag_no
     if tagno == nil
        if Book.all.count>0 
	    self.tagno = (Book.last.tagno.to_i+1).to_s if Book.last.tagno
	else
	    self.tagno=1
	end
     end 
  end

  def extract_roman_into_size_pages
     self.backuproman = roman if id.nil? || id.blank?			#only for existing one
     roman_list=LibraryHelper.roman_list2
     
     #roman, size, pages
     if roman != nil 
	if roman.include?(",") 
	  ar = roman.split(',')
	elsif roman.include?(";") 
	  ar = roman.split(';')
	elsif roman.include?(":")
	  ar = roman.split(':')
	else
	    r2=roman.lstrip[-2,2]
	    if r2=="ms"
		self.pages=roman.lstrip
	    elsif r2=="cm"
		self.size=roman.lstrip
	    elsif r2!="ms" || r2!="cm"
	        if roman_list.include?(roman.lstrip)
		    self.roman=roman.lstrip
		else
		    self.roman=''
		end
	    end
	end    
	if ar
	   ar.each do |a|
	     a2= a.lstrip[-2,2]
	      if a2=="ms"
		  self.pages=a.lstrip
	      elsif a2=="cm"
		  self.size=a.lstrip
	      elsif a2!="ms" || a2!="cm"
		  if roman_list.include?(a.lstrip)
		    self.roman=a.lstrip
		  else
		    self.roman=''
		  end
	      end
	   end	
	   if self.roman==self.backuproman && ar.count>1
	     self.roman=nil	#force nil for nothing
	   end
	end
      end
      
  end 
  
  def book_quantity
      Accession.where(book_id: id).count
  end
  
  # define scope media type
  def self.mediatype_search(query) 
    where(mediatype: query.to_i)
  end
  
  # define scope status
  def self.status_search(query)
    where(status: query.to_i)
  end
  
  #define scope accessionno
  def self.accessionno_search(query)
    Book.joins(:accessions).where('accessions.accession_no ILIKE(?)', "%#{query}%")
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:mediatype_search]
    [:status_search]
    [:accessionno_search]
  end
  
  def self.import(file) 
    spreadsheet = Spreadsheet2.open_spreadsheet(file) 
    result = LibraryHelper.update_book_accession(spreadsheet)
    return result
  end
  
  def self.messages(import_result) 
    LibraryHelper.msg_import(import_result)
  end
  
  def self.messages2(import_result) 
    LibraryHelper.msg_import2(import_result)
  end
  
  def callingno
    if classlcc!=""
      c=classlcc
    else
      c=classddc
    end
    c
  end
  
end

# == Schema Information
#
# Table name: books
#
#  accessionno        :string(255)
#  author             :string(255)
#  backuproman        :string(255)
#  bibliography       :string(255)
#  bookcode           :string(255)
#  catsource          :string(255)
#  classddc           :string(255)
#  classlcc           :string(255)
#  controlno          :string(255)
#  created_at         :datetime
#  description        :string(255)
#  edition            :string(255)
#  id                 :integer          not null, primary key
#  indice             :string(255)
#  isbn               :string(255)
#  issn               :string(255)
#  language           :string(255)
#  links              :text
#  loantype           :integer
#  location           :string(255)
#  mediatype          :integer
#  notes              :string(255)
#  orderno            :string(255)
#  pages              :string(255)
#  photo_content_type :string(255)
#  photo_file_name    :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  publish_date       :string(255)
#  publish_location   :string(255)
#  publisher          :string(255)
#  purchasedate       :date
#  purchaseprice      :decimal(, )
#  quantity           :integer
#  receiveddate       :date
#  receiver_id        :integer
#  roman              :string(255)
#  series             :string(255)
#  size               :string(255)
#  status             :integer
#  subject            :text
#  supplier_id        :integer
#  tagno              :string(255)
#  title              :string(255)
#  topic              :string(255)
#  updated_at         :datetime
#
