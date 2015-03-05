class Student::TenantsController < ApplicationController
  
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = Tenant.where("student_id IS NOT NULL").search(params[:q])
    @search.keyreturned_present != nil unless params[:q]
    @search.force_vacate_true = false unless params[:q]
    @search.sorts = 'location_combo_code asc' if @search.sorts.empty?
    @tenants = @search.result
  
    #reports - will move out
    #getting buidings with student beds
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    roots = []
    @places.each do |place|
     roots << place.root
    end
    @residentials = roots.uniq
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)

  end
  
  def room_map
    @residentials = Location.where(lclass: 4).order(combo_code: :asc)
    #sets div size to fit no of buildings 
    @div_width = 90/@residentials.count
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    @occupied_locations = @current_tenants.pluck(:location_id)
  end
  
  def statistics
    @locations = Location.where('typename IN (?)', [2,8])
    @female_student_beds  = @locations.where('typename = ?', 2)
    @male_student_beds    = @locations.where('typename = ?', 8)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    @occupied_locations = @current_tenants.pluck(:location_id)
  end
  
  def census
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    roots = []
    @places.each do |place|
      roots << place.root
    end
    @residentials = roots.uniq
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    
    respond_to do |format|
      format.pdf do
        pdf = CensusStudentTenantsPdf.new(@residentials, @current_tenants, current_user)
        send_data pdf.render, filename: "census",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def return_key
    if params[:search] && params[:search][:student_icno].present?
      @student_ic = params[:search][:student_icno]
      @ic_only = @student_ic.split(" ")[0]
      #@selected_student = Student.where("icno = ?", "#{@student_ic}").first
      @my_room = Tenant.where(student_id: Student.where("icno = ?", "#{@ic_only}").first).first
    end
    @tenant = @my_room
  end

  
  
  
  def new
    @current_tenant_ids = Tenant.where(:keyreturned => nil).where(:force_vacate => false).pluck(:student_id)
    @potential1=Student.where(gender: 1).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
    @potential2=Student.where(gender: 2).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
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
        format.html { redirect_to student_tenant_path(@tenant), notice: (t 'location.title')+(t 'actions.updated')  }
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
      #format.html { redirect_to student_tenants_url }
      format.html { redirect_to room_map_student_tenants_path }
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
      params.require(:tenant).permit(:location_id, :staff_id, :student_id, :keyaccept, :keyexpectedreturn, :keyreturned, :force_vacate, :student_icno, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end
  
end