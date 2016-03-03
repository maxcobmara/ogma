class Group < ActiveRecord::Base
  serialize :members, Hash  
  
  #define scope
  def self.members_search(query)
    if query
      user_ids = User.where(userable_id: Staff.where('name ILIKE?', "%#{query}%").pluck(:id)).pluck(:id)
      group_ids=[]
      for user_id in user_ids
        Group.all.each do |gr|
          group_ids << gr.id if gr.listing.include?(user_id)
        end
      end
      Group.where(id: group_ids)
    end
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:members_search]
  end
  
  def listing
    list=[]
    (members[:user_ids]-[""]).each{|x| list << x.to_i}
    list
  end
end
