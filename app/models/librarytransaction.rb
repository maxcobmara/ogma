class Librarytransaction < ActiveRecord::Base

  belongs_to :accession
  belongs_to :staff
  belongs_to :student
  belongs_to :libcheckoutby, :class_name => 'Staff', :foreign_key => 'libcheckout_by'
  belongs_to :libextendby, :class_name => 'Staff', :foreign_key => 'libextended_by'
  belongs_to :libreturnby, :class_name => 'Staff', :foreign_key => 'libreturned_by'

  before_save :set_fine_paid_value_exist, :set_default_finepaydate, :set_default_checkoutdate_returnduedate
  after_save :update_book_status
  before_destroy :update_book_status2
  
  attr_accessor :booktitle, :staf_who, :student_who, :newduedate, :late_days_count
  
  #validates :accession_id , presence: true
  #validates :checkoutdate, :returnduedate, presence: true
  
  def update_book_status
    acc_to_update=Accession.find(accession_id)
    if returned==true
      acc_to_update.status=1 #available
    else
      acc_to_update.status=2 #on loan
    end
    acc_to_update.save!
  end
  
  def update_book_status2
    acc_to_update=Accession.find(accession_id)
    acc_to_update.status=1 #available
    acc_to_update.save!
  end
  
  #18May2013-compulsory to have this method in order for autocomplete field to work

  #scope :borrowed, -> {where("returned = ? OR returned IS ?", false, nil)}
  
  ##scope :all,       :conditions => [ "id IS NOT ?", nil ]
  scope :borrowed,  lambda{where("returned = ? OR returned IS ?", false, nil)}
  ##scope :returned,  :conditions => ["returned = ? AND returneddate > ?", true, 8.days.ago]
  #scope :overdue,   lambda{where("returnduedate < ? AND returneddate IS ?", 1.day.ago, nil)}
  ##scope :overdue, lambda { |time| { :conditions => ["returnduedate < ? AND returneddate !=?", Time.now, nil] } }
  scope :overdue, lambda{where("returneddate > returnduedate")}
  
  FILTERS = [
    #{:scope => "all",        :label => "Semua transaksi"},   #All 
    {:scope => "borrowed",   :label => "Sedang dipinjam"},    #Borrowed
    #{:scope => "returned",   :label => "Telah dipulangkan"},  #Returned
    {:scope => "overdue",    :label => "Tamat Tempoh"}        #Overdue
  ]
  
  #define scope
  def self.borrower_search(query)
    staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    student_ids=Student.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    where('student_id=? OR staff_id=?', student_ids, staff_ids)
  end 
  
  def self.callno_search(query)
    book_ids=Book.where('classlcc ILIKE(?) or classddc ILIKE(?)', "%#{query}%", "%#{query}%").pluck(:id)
    accession_ids=Accession.where(book_id: book_ids).pluck(:id)
    where(accession_id: accession_ids)
  end
  
  def self.borrowed_overdue_search(query)
    if query=='1'
      where(returned: nil).where('returnduedate >=?', Date.today.yesterday)
    elsif query=='2'
      where(returned: nil).where('returnduedate <?', Date.today.yesterday)
    end
  end
  
  #whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:borrower_search, :callno_search, :borrowed_overdue_search]
  end
  
  #return due books fr manager pg
  def set_fine_paid_value_exist
    if fine && fine > 0 && finepay!=true
      self.finepay=true
      self.finepaydate=Date.today
    end
  end
  
  def set_default_finepaydate
    if finepay==true && finepaydate==nil
      self.finepaydate=Date.today
    end
  end
  
  def set_default_checkoutdate_returnduedate
    if checkoutdate.blank?
      self.checkoutdate=Date.today
    end
    if returnduedate.blank?
      if ru_staff==true
        self.returnduedate=Date.today+21.days
      else
        self.returnduedate=Date.today+14.days
      end
    end
  end
  
  def accession_acc_book
    accession.try(:acc_book)
  end

  def accession_acc_book=(acc_book)
    accession_no = acc_book.split(" ")[0]
    self.accession = Accession.find_by_accession_no(accession_no) if accession_no.present?
  end
  
  def borrower_name
    if ru_staff?
      staff.try(:staff_with_rank)
    else
      student.try(:student_with_rank)
    end
  end
  
  def extended_due
    if ru_staff==true
      returnduedate+21.days
    else
      returnduedate+14.days
    end
  end
  
  def recommended_fine
    (Date.today.yesterday-returnduedate)*1.0
  end
  
  def late_days
    (returneddate-returnduedate).to_i if returneddate > returnduedate
  end

end

# == Schema Information
#
# Table name: librarytransactions
#
#  accession_id   :integer
#  checkoutdate   :date
#  created_at     :datetime
#  extended       :boolean
#  fine           :decimal(, )
#  finepay        :boolean
#  finepaydate    :date
#  id             :integer          not null, primary key
#  libcheckout_by :integer
#  libextended_by :integer
#  libreturned_by :integer
#  replaceddate   :date
#  report         :text
#  reportlost     :boolean
#  reportlostdate :date
#  returnduedate  :date
#  returned       :boolean
#  returneddate   :date
#  ru_staff       :boolean
#  staff_id       :integer
#  student_id     :integer
#  updated_at     :datetime
#
