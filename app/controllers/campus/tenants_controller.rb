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
    
    
    @current_tenants = Tenant.where(:keyreturned => nil).where(:force_vacate => false)
    @occupied_locations = @current_tenants.pluck(:location_id)
  end
  
end