class College < ActiveRecord::Base
  has_many :users
  has_many :pages
  #student, staffs
  
  serialize :data, Hash
  
  def address=(value)
    data[:address]=value
  end
  
  def address
    data[:address]
  end
  
  def phone=(value)
    data[:phone]=value
  end
  
  def phone
    data[:phone]
  end
  
  def fax=(value)
    data[:fax]=value
  end
  
  def fax
    data[:fax]
  end
  
  def email=(value)
    data[:email]=value
  end
    
  def email
    data[:email]
  end
  
  def logo=(value)
    data[:logo]=value
  end
  
  def logo
    data[:logo]
  end  
  
end