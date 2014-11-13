class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :userable, polymorphic: true
  has_and_belongs_to_many :roles

  def self.keyword_search(query) 
   staff_ids=Staff.where('name ILIKE(?)', "%#{query}%").pluck(:id)
   student_ids=Student.where('name ILIKE(?)', "%#{query}%").pluck(:id)
   where('(userable_id IN(?) and userable_type=?) OR userable_id IN(?) and userable_type=? ', staff_ids, "Staff", student_ids, "Student")
  end

  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
   [:keyword_search]
  end

  
  def role_symbols
   roles.map do |role|
    role.authname.to_sym
   end
  end
end
