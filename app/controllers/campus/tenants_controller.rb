class Campus::TenantsController < ApplicationController
  
  def index
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    
    roots = []
    @places.each do |place|
      roots << place.root
    end
    @residentials = roots.uniq
      
    @div_width = 90/@residentials.count
    
    @tenants = Tenant.order(created_at: :desc)
  end
  
end