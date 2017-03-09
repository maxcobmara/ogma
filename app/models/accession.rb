class Accession < ActiveRecord::Base
  serialize :data, Hash
  
  #before_save :one_reservation_per_copy
  
  has_many :librarytransactions
  belongs_to :book
  
  validates :accession_no, uniqueness: true
  
  def self.search2(query)
    acc_ids=[]
    #as reserver
    Accession.where.not(data: nil).each do |reserve|
      acc_ids << reserve.id if reserve.reserver_ids.include?(query)
    end
    #as borrower of reserved book
    curr_usrable_id=User.find(query).userable_id
    Accession.where.not(data: nil).each do |reserve|
      loan=reserve.librarytransactions.last
      brwtype=loan.ru_staff
      acc_ids << reserve.id if brwtype==true && curr_usrable_id==loan.staff_id
      acc_ids << reserve.id if brwtype==false && curr_usrable_id==loan.student_id
    end
    where(id: acc_ids)
  end
  
  def self.existing_reservations
    acc_ids=[]
    Accession.where.not(data: nil).each{|reserve|acc_ids << reserve.id if !reserve.reservations.blank?}
    acc_ids
  end
  
  #define scope
  def self.reserved_by_search(query)
    staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    student_ids=Student.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    user_ids=User.where('(userable_type=? and userable_id IN(?)) OR (userable_type=? and userable_id IN(?))', 'Staff', staff_ids,'Student', student_ids).pluck(:id)
    acc_ids=[]
    Accession.where.not(data: nil).each do |reserve|
      user_ids.each{|ui| acc_ids << reserve.id if reserve.reserver_ids.include?(ui)}
    end
    where(id: acc_ids)
  end
  
  def self.reservation_date_search(query)
    acc_ids=[]
    Accession.where.not(data: nil).each do |reserve|
      acc_ids << reserve.id if reserve.reservation_dates.include?(query)
    end
    where(id: acc_ids)
  end
  
  def self.borrowed_by_search(query)
    staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    student_ids=Student.where('name ILIKE(?)', "%#{query}%").pluck(:id)
    acc_ids=[]
    Accession.where.not(data: nil).each do |reserve|
      loan=reserve.librarytransactions.last
      brwtype=loan.ru_staff
      acc_ids << reserve.id if brwtype==true && staff_ids.include?(loan.staff_id)
      acc_ids << reserve.id if brwtype==false && student_ids.include?(loan.student_id)
    end
    where(id: acc_ids)
  end
  
  def self.returnduedate_search(query)
    acc_ids=[]
    Accession.where.not(data: nil).each do |reserve|
      loan=reserve.librarytransactions.last
      acc_ids << reserve.id if loan.returnduedate.strftime('%d-%m-%Y')==query
    end
    where(id: acc_ids)
  end
  
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:reserved_by_search, :reservation_date_search, :user_type_search, :borrowed_by_search, :returnduedate_search]
  end
  
  def acc_book
    "#{accession_no} - #{book.title}"
  end
  
  def reservations=(value)
    data[:reservations] = value
  end
  
  def reservations
    data[:reservations]
  end
  
  def activate_date=(value)
    data[:activate_date] = value
  end
  
  def activate_date
    data[:activate_date]
  end
  
  def reserver_ids
    ree=[]
    unless reservations.blank?
      reservations.values.each{|x|ree << x["reserved_by"].to_i}
    end
    ree
  end
  
  def reservation_dates
    ree=[]
    unless reservations.blank?
      reservations.values.each{|x|ree << x["reservation_date"]}
    end
    ree
  end
  
  def borrower_details
    loan=Librarytransaction.where(accession_id: id).last
    if loan.ru_staff==true 
      str="#{loan.staff.staff_with_rank} (#{I18n.t 'library.reservation.staff'}) - #{loan.staff.try(:coemail)}" 
    elsif loan.ru_staff==false
      str="#{loan.student.student_with_rank} (#{(I18n.t 'library.reservation.student')}) - #{loan.student.try(:semail)}"
    end 
    str      
  end
  
  def render_book_status
    if book.college.code=='amsas'
      book_status=Book::STATUS_AMSAS
    else
      book_status=Book::STATUS 
    end
    (book_status.find_all{|disp, value| value==status}).map{|disp, value|disp}.first
  end
  
#   def one_reservation_per_copy
#     unless reservations.blank?
#       ree=[]
#       for reserve in reservations.values
#         ree << reserve["reserved_by"]
#       end
#       if ree.count!=ree.uniq.count
# 	return false
#         errors.add(:base, "Reservation of this book can only be done once!") #Anda hanya boleh menempah buku ini sekali sahaja!
#       else
# 	return true
#       end
#     end
#   end
  
end

# == Schema Information
#
# Table name: accessions
#
#  accession_no   :string(255)
#  book_id        :integer
#  created_at     :datetime
#  id             :integer          not null, primary key
#  order_no       :string(255)
#  purchase_price :decimal(, )
#  received       :date
#  received_by    :integer
#  supplied_by    :integer
#  updated_at     :datetime
#
