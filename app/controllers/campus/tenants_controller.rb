class Campus::TenantsController < ApplicationController
  
  def index
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    @residentials = @places.roots.uniq
    @tenants = Tenant.order(created_at: :desc)
  end
  
end