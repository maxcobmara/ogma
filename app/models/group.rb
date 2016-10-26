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
  
  def self.membership_search(query)
    if query #user id is sent/selected, otherwise - value=0
      group_member=[]
      Group.all.each do |gr|
        group_member << gr.id if gr.listing.include?(query.to_i)
      end
      if query.to_i!=0 
        #search for own group
        group_ids=group_member
      else
        #search for non own group
        group_ids = Group.all.pluck(:id)-group_member
      end
      Group.where(id: group_ids)
    end
  end
    
  # whitelist the scope
  def self.ransackable_scopes(auth_object = nil)
    [:members_search, :membership_search]
  end
  
  def listing
    list=[]
    (members[:user_ids]-[""]).each{|x| list << x.to_i}
    list
  end
  
  def is_member(u)
    if listing.include?(u)
      return true
    else
      return false
    end
  end
  
  #usage - documents/tab_circulation_details.html.haml
  def staffids_list
    User.where(id: (members[:user_ids]-[""])).pluck(:userable_id) 
  end
  
  #usage - documents/_form.html.haml
  def group_staffids_list
    [(I18n.t 'group.groups')+name, staffids_list]
  end
end
