class Student::TenantsController < ApplicationController
  
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  
  def index
    #getting buidings with student beds
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    roots = []
    @places.each do |place|
      roots << place.root
    end
    @residentials = roots.uniq
    #sets div size to fit no of buildings 
    @div_width = 90/@residentials.count
    
    @current_tenants = Tenant.where(:keyreturned => nil).where(:force_vacate => false)
    @occupied_locations = @current_tenants.pluck(:location_id)
    
    
    @tenants = Tenant.order(created_at: :desc)
  end
  
  def new
    @current_tenant_ids = Tenant.where(:keyreturned => nil).where(:force_vacate => false).pluck(:student_id)
    @tenant = Tenant.new(:location_id => params[:location_id])
    
  end
  
  def edit
  end
  
  def create
    @tenant = Tenant.new(tenant_params)

    respond_to do |format|
      if @tenant.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(student_tenant_path(@tenant)) }
        format.xml  { render :xml => @tenant, :status => :created, :location => @tenant }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tenant.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @tenant.update(tenant_params)
        format.html { redirect_to student_location_path(@tenant), notice: (t 'location.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
  end
  
  def destroy
    @tenant.destroy
    respond_to do |format|
      format.html { redirect_to student_tenant_url }
      format.json { head :no_content }
    end
  end
  
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_params
      params.require(:tenant).permit(:location_id, :staff_id, :student_id, :keyaccept, :keyexpectedreturn, :keyreturned, :force_vacate, :student_name)
    end
  
end