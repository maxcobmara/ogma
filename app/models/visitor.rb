class Visitor < ActiveRecord::Base
  has_many :tenants
  has_many :librarytransactions
  has_many :evaluate_courses
  has_many :average_courses
  belongs_to :college
  belongs_to :address_book
  belongs_to :rank
  belongs_to :title
  
  validates :name, :icno, :hpno, presence: true
  validate :department_or_address_must_exist, :position_must_exist_when_no_rank
  
  before_save :set_department_or_addressbook, :set_expertise_when_blank

  def visitor_with_title_rank
    unless rank_id.blank?
      a=rank.try(:shortname)
    else
      a=title.try(:name)
    end
    "#{a} #{name}"
  end
  
  def visitor_with_title 
    "#{title.try(:name)} #{name}"
  end
  
  def organisation_details
    unless department.blank?
      department
    else
      address_book.name
    end
  end
  
  def set_department_or_addressbook
    if corporate==true
      self.department=nil
    else
      self.address_book_id=nil
    end
  end
  
  def set_expertise_when_blank
    if expertise.blank?
      self.expertise=""
    end
  end
  
  def department_or_address_must_exist
    if department.blank? && address_book_id.blank?
      errors.add(:base, "#{I18n.t('campus.visitors.department_or_address_must_exist')}")
    end
  end
  
  def position_must_exist_when_no_rank
    if rank_id.blank? && position.blank?
      errors.add(:base, "#{I18n.t('campus.visitors.position_must_exist_when_no_rank')}")
    end
  end
  
  #usage - to record visitors (not registered as staff / students in icms) - to be used as above relationships)
#     
#   t.string :name
#       t.string :icno
#       t.integer :rank_id
#       t.integer :title_id
#       t.string :phoneno
#       t.string :hpno
#       t.string :email
#       t.string :expertise
#       t.boolean :corporate
#       t.string :department
#       t.integer :address_book_id
end
