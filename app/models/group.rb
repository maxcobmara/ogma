class Group < ActiveRecord::Base
  serialize :members, Hash  
  def listing
    list=[]
    (members[:user_ids]-[""]).each{|x| list << x.to_i}
    list
  end
end
