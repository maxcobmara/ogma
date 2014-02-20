class Librarytransaction < ActiveRecord::Base
  
  
  belongs_to :accession
  belongs_to :staff
  belongs_to :student
  belongs_to :libcheckoutby, :class_name => 'Staff', :foreign_key => 'libcheckout_by'
  belongs_to :libextendby, :class_name => 'Staff', :foreign_key => 'libextended_by'
  belongs_to :libreturnby, :class_name => 'Staff', :foreign_key => 'libreturned_by'
  
  attr_accessor :booktitle, :staf_who, :student_who
  
  validates_presence_of :accession_id
  validate :staff_or_student_borrower
  
  #18May2013-compulsory to have this method in order for autocomplete field to work
  def staff_who
  end
  def student_who
  end

  def staff_or_student_borrower
    if %w(staff_id student_id).all?{|attr| self[attr].blank?}
      errors.add_to_base("A borrower is required")
    end
  end
  
  #scope :all,       :conditions => [ "id IS NOT ?", nil ]
  scope :borrowed,  lambda{where("returned = ? OR returned IS ?", false, nil)}
  #scope :returned,  :conditions => ["returned = ? AND returneddate > ?", true, 8.days.ago]
  scope :overdue,   lambda{where("returnduedate < ? AND returneddate IS ?", 1.day.ago, nil)}
  #scope :overdue, lambda { |time| { :conditions => ["returnduedate < ? AND returneddate !=?", Time.now, nil] } }
  
  FILTERS = [
    #{:scope => "all",        :label => "Semua transaksi"},   #All 
    {:scope => "borrowed",   :label => "Sedang dipinjam"},    #Borrowed
    #{:scope => "returned",   :label => "Telah dipulangkan"},  #Returned
    {:scope => "overdue",    :label => "Tamat Tempoh"}        #Overdue
  ]
  
  def accession_acc_book
    accession.try(:acc_book)
  end

  def accession_acc_book=(acc_book)
    accession_no = acc_book.split(" ")[0]
    self.accession = Accession.find_by_accession_no(accession_no) if accession_no.present?
  end
  
  def borrower_name
    if ru_staff?
      staff.try(:name)
    else
      student.try(:name)
    end
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
