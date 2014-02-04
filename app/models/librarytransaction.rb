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
  
  def borrower_name
   stid = Array(staff_id)
   suid = Array(student_id)
   stexists = Staff.where(id: "id").map(&:id)
   stuexists = Student.where(id: "id").map(&:id)
   staffchecker = stid & stexists
   studentchecker = suid & stuexists
   
      if student_id == 0 && staff_id == 0 #student_id == nil && staff_id == nil 
           "" 
      elsif staff_id == 0 && stexists == [] #staff_id == nil && stexists == []
           "Student No Longer Exists" 
      elsif student_id == 0 && stuexists == []  #student_id == nil && stuexists == []
          "Staff No Longer Exists" 
      elsif student_id == 0
          staff.name
      elsif staff_id == 0
          student.name
      end
  end
end