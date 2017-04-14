class Staffsearch2 < ActiveRecord::Base

  belongs_to :college
  
  def staffs
    @staffs ||= find_staffs
  end
  
  private

  def find_staffs
    Staff.where(conditions).order(orders)
  end

  def keyword_conditions
    unless keywords.blank?
      icno_name=keywords.gsub("-","")
      name=icno_name.gsub(/\d+/,"").strip
      ["staffs.name ILIKE ?", "%#{name}%"]    #["staffgrade.name ILIKE ?", "%#{keywords}%"] unless keywords.blank?#
    end
  end
  
  #Bersepadu (4)
  #Sokongan (2)
  #Pengurusan & Profesional (1)
 
  #when ONE group selected
  def bersepadu
    #a='(staffgrade_id=? ' if  Employgrade.find(:all, :conditions=>['group_id=?', 4]).map(&:id).uniq.count!=0
    a='(staffgrade_id=? ' if  Employgrade.where('group_id=?', 4).map(&:id).uniq.count!=0
    #0.upto(Employgrade.find(:all, :conditions=>['group_id=?', 4]).map(&:id).uniq.count-2) do |l|  
    0.upto(Employgrade.where('group_id=?', 4).map(&:id).uniq.count-2) do |l|  
      a=a+'OR staffgrade_id=? '
    end
    a=a+')'
    return a if position==1 && position2==0 && position3==0
    
    #b='(staffgrade_id=? ' if  Employgrade.find(:all, :conditions=>['group_id=?', 2]).map(&:id).uniq.count!=0
    b='(staffgrade_id=? ' if  Employgrade.where('group_id=?', 2).map(&:id).uniq.count!=0
    #0.upto(Employgrade.find(:all, :conditions=>['group_id=?', 2]).map(&:id).uniq.count-2) do |l|  
    0.upto(Employgrade.where('group_id=?', 2).map(&:id).uniq.count-2) do |l|  
      b=b+'OR staffgrade_id=? '
    end
    b=b+')'
    return b if position==0 && position2==1 && position3==0
      
    #c='(staffgrade_id=? ' if  Employgrade.find(:all, :conditions=>['group_id=?', 1]).map(&:id).uniq.count!=0
    c='(staffgrade_id=? ' if  Employgrade.where('group_id=?', 1).map(&:id).uniq.count!=0
    #0.upto(Employgrade.find(:all, :conditions=>['group_id=?', 1]).map(&:id).uniq.count-2) do |l|  
    0.upto(Employgrade.where('group_id=?', 1).map(&:id).uniq.count-2) do |l|  
      c=c+'OR staffgrade_id=? '
    end
    c=c+')'
    return c if position==0 && position2==0 && position3==1
  end 
  
  def position_conditions 
    if position==1 && position2==0 && position3==0
      #return [bersepadu, Employgrade.find(:all,:conditions=>['group_id=?', 4]).map(&:id) ]#unless position.blank? 
      return [bersepadu, Employgrade.where('group_id=?', 4).map(&:id) ]#unless position.blank? 
    elsif position==0 && position2==1 && position3==0
      #return [bersepadu, Employgrade.find(:all,:conditions=>['group_id=?', 2]).map(&:id) ]
      return [bersepadu, Employgrade.where('group_id=?', 2).map(&:id) ]
    elsif position==0 && position2==0 && position3==1
      #return [bersepadu, Employgrade.find(:all,:conditions=>['group_id=?', 1]).map(&:id) ]
      return [bersepadu, Employgrade.where('group_id=?', 1).map(&:id) ]
    end
  end 
 
  #when TWO groups selected
  def sokongan
    #a='(staffgrade_id=? ' if  Employgrade.find(:all, :conditions=>['group_id=? or group_id=?', 4,2]).map(&:id).uniq.count!=0
    a='(staffgrade_id=? ' if  Employgrade.where('group_id=? or group_id=?', 4,2).map(&:id).uniq.count!=0
    #0.upto(Employgrade.find(:all, :conditions=>['group_id=? or group_id=?', 4,2]).map(&:id).uniq.count-2) do |l|  
    0.upto(Employgrade.where('group_id=? or group_id=?', 4,2).map(&:id).uniq.count-2) do |l|  
      a=a+'OR staffgrade_id=? '
    end
    a=a+')'
    return a if position==1 && position2==1 && position3==0
      
    #b='(staffgrade_id=? ' if  Employgrade.find(:all, :conditions=>['group_id=? or group_id=?', 4,1]).map(&:id).uniq.count!=0
    b='(staffgrade_id=? ' if  Employgrade.where('group_id=? or group_id=?', 4,1).map(&:id).uniq.count!=0
    #0.upto(Employgrade.find(:all, :conditions=>['group_id=? or group_id=?', 4,1]).map(&:id).uniq.count-2) do |l|  
    0.upto(Employgrade.where('group_id=? or group_id=?', 4,1).map(&:id).uniq.count-2) do |l|  
      b=b+'OR staffgrade_id=? '
    end
    b=b+')'
    return b if position==1 && position2=0 && position3==1
      
    #c='(staffgrade_id=? ' if  Employgrade.find(:all, :conditions=>['group_id=? or group_id=?', 2,1]).map(&:id).uniq.count!=0
    c='(staffgrade_id=? ' if  Employgrade.where('group_id=? or group_id=?', 2,1).map(&:id).uniq.count!=0
    #0.upto(Employgrade.find(:all, :conditions=>['group_id=? or group_id=?', 2,1]).map(&:id).uniq.count-2) do |l|  
    0.upto(Employgrade.where('group_id=? or group_id=?', 2,1).map(&:id).uniq.count-2) do |l|  
      c=c+'OR staffgrade_id=? '
    end
    c=c+')'
    return c if position==0 && position2=1 && position3==1
  end 
   
  def position2_conditions 
    if position==1 && position2==1 && position3==0
       #[sokongan, Employgrade.find(:all,:conditions=>['group_id=? or group_id=?', 4,2]).map(&:id) ] 
       [sokongan, Employgrade.where('group_id=? or group_id=?', 4,2).map(&:id) ] 
    elsif position==1 && position2==0 && position3==1
       #[sokongan, Employgrade.find(:all,:conditions=>['group_id=? or group_id=?', 4,1]).map(&:id) ] 
       [sokongan, Employgrade.where('group_id=? or group_id=?', 4,1).map(&:id) ] 
    elsif position==0 && position2==1 && position3==1
       #[sokongan, Employgrade.find(:all,:conditions=>['group_id=? or group_id=?', 2,1]).map(&:id) ] 
       [sokongan, Employgrade.where('group_id=? or group_id=?', 2,1).map(&:id) ] 
    end 
  end 
  
  #when THREE groups selected
  def pengurusan_profesional
    #a='(staffgrade_id=? ' if  Employgrade.find(:all, :conditions=>['group_id=? or group_id=? or group_id=?', 4,2,1]).map(&:id).uniq.count!=0
    a='(staffgrade_id=? ' if  Employgrade.where('group_id=? or group_id=? or group_id=?', 4,2,1).map(&:id).uniq.count!=0
    #0.upto(Employgrade.find(:all, :conditions=>['group_id=? or group_id=? or group_id=?', 4,2,1]).map(&:id).uniq.count-2) do |l|  
    0.upto(Employgrade.where('group_id=? or group_id=? or group_id=?', 4,2,1).map(&:id).uniq.count-2) do |l|
      a=a+'OR staffgrade_id=? '
    end
    a=a+')'
    return a if position==1 && position2==1 && position3==1
  end 
   
  def position3_conditions 
    #[pengurusan_profesional, Employgrade.find(:all,:conditions=>['group_id=? or group_id=? or group_id=?', 4,2,1]).map(&:id) ] if position==1 && position2==1 && position3==1
    [pengurusan_profesional, Employgrade.where('group_id=? or group_id=? or group_id=?', 4,2,1).map(&:id) ] if position==1 && position2==1 && position3==1
  end 


  def staffgrade_conditions
    [" (staffgrade_id =?)" , staff_grade] unless staff_grade.blank?
  end
  
  #def category_conditions
    #["staffs.category_id = ?", category_id] unless category_id.blank?
  #end
  
  def orders
   "staffgrade_id ASC"
  end  

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options] #works like OR?????
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end
  
end
