class Campus::LocationsController < ApplicationController
  #filter_access_to :all
  filter_access_to :index, :new, :create, :statistic_level, :census_level2, :statistic_block, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :kewpa7, :kewpa10, :kewpa11,  :attribute_check => true
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  
  def index
      #@filters = Location::FILTERS
      #if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      #  @locations = Location.send(params[:show])
      #else
      #  @locations = Location.search(params[:search])
      #end
      @locations = Location.all
      @root_locations = Location.roots.order(code: :asc)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end
  
  def new
    @location = Location.new(:parent_id => params[:parent_id])
  end
  
  def edit
    #@location.damages.new if @location.occupied==0
    #@location.damages.build
    #@location.damages.build if (@location.damages && !@location.damages.pluck(:repaired_on).include?(nil))  #create new if ALL previous damages repaired
    
  end
  
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(campus_location_path(@location)) }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html {redirect_to campus_location_path(@location.parent || @location), notice: (t 'location.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end
    
  
  def show
  end
  
  def destroy
    respond_to do |format|
      if @location.destroy
        format.html { redirect_to campus_locations_url }
        format.json { head :no_content }
      else
        errors_line=""
        @location.errors.each{|k,v| errors_line+="<li>#{v}</li>"}
        format.html { redirect_to campus_location_path(@location), notice: ("<span style='color: red;'>"+ I18n.t('activerecord.errors.invalid_removal')+"<ol>"+errors_line+"</ol></span>").html_safe}
        format.json { head :no_content }
      end
    end
  end
  
  def kewpa7
    @location = Location.find(params[:id])
    placements = AssetPlacement.where(location_id:params[:id]).order(:asset_id, reg_on: :asc).group_by(&:asset_id)
    pp=[]
    placements.each do |asset, details|
      count=0
      details.each do |d|
        pp << d.id if count==0  #pp - capture asset_placement ids
        count+=1
      end
    end
    @asset_placements = AssetPlacement.where('id IN(?)', pp)
    #@asset_admin = Role.where(id:11).first.users.where('login=?',"norasikin").first 		#temp
    @asset_admin = Role.where(name: "Asset Administrator").first.users.first
    respond_to do |format|
      format.pdf do
        pdf = Kewpa7Pdf.new(@location, @asset_admin, @asset_placements, current_user.college)
        send_data pdf.render, filename: "order_#{@location.combo_code}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def kewpa10
#     @location = Location.find(params[:id])
#     placements = AssetPlacement.where(location_id: params[:id]).order(:asset_id, reg_on: :asc).group_by(&:asset_id)
#     pp=[]
#     placements.each do |asset, details|
#       count=0
#       details.each do |d|
#         pp << d.id if count==0  #pp - capture asset_placement ids
#         count+=1
#       end
#     end
#     @asset_placements = AssetPlacement.where('id IN(?)', pp)
    
    #@asset_placements=AssetPlacement.where(location_id: params[:id])
    
    # NOTE - collect all HM (fixed) asset located at this location
    assets_located_at=Asset.where(location_id: params[:id])
    
    respond_to do |format|
      format.pdf do
        pdf = Kewpa10Pdf.new(@location, view_context, assets_located_at, current_user.college)
        send_data pdf.render, filename: "kewpa10-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  def kewpa11
    @location = Location.find(params[:id])
    
    respond_to do |format|
      format.pdf do
        pdf = Kewpa11Pdf.new(@location, view_context)#, @assets)
        send_data pdf.render, filename: "kewpa11-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  #moved from Tenants Controller
  #Excel - Statistic by level (of selected block) - link at app/views/student/tenants/reports.html.haml
  def statistic_level 
    buildingname = params[:buildingname]
    @rooms = Location.where('name LIKE (?) and lclass=?', "#{buildingname}", 4).first.descendants.where(typename: [2,8])
    roles=current_user.roles.pluck(:authname)
    if roles.include?('developer') || (roles.include?('administration') && User.icms_acct.include?(current_user.id))
      respond_to do |format|
        format.html
        format.csv { send_data @rooms.to_csv_all }
        format.xls { send_data @rooms.to_csv_all(col_sep: "\t") } 
      end
    else
      respond_to do |format|
        format.html
        format.csv { send_data @rooms.to_csv }
        format.xls { send_data @rooms.to_csv(col_sep: "\t") } 
      end
    end
  end
  
  #moved from Tenants Controller
  #Excel - Census by level - link at app/views/student/tenants/census_level.html.haml
  def census_level2
    @floor_id = params[:floorid]
    @all_beds_single=Location.find(@floor_id).descendants.where('typename = ? OR typename =?', 2, 8)
    roles=current_user.roles.pluck(:authname)
    if roles.include?('developer') || (roles.include?('administration') && User.icms_acct.include?(current_user.id))
      respond_to do |format|
        format.html
        format.csv { send_data @all_beds_single.to_csv2_all}
        format.xls { send_data @all_beds_single.to_csv2_all(col_sep: "\t") }    ##generate_line(["=\"01\""], ...)
      end                                                                                                         #CSV.generate_line(["01"], :force_quotes => true)
    else
      respond_to do |format|
        format.html
        format.csv { send_data @all_beds_single.to_csv2}
        format.xls { send_data @all_beds_single.to_csv2(col_sep: "\t") }    ##generate_line(["=\"01\""], ...)
                                                                                                                 #CSV.generate_line(["01"], :force_quotes => true)
      end
    end
  end
  
  #moved from Tenants Controller
  #Excel - Statistic by block (room status & tenants group by programme) - link at app/views/student/tenants/statistics.html.haml
  def statistic_block
    @block_id = params[:blockid]
    @all_beds_single=Location.find(@block_id).descendants.where('typename = ? OR typename =?', 2, 8)#.sort_by{|y|y.combo_code}

    respond_to do |format|
      format.html
      format.csv { send_data @all_beds_single.to_csv3}
      format.xls { send_data @all_beds_single.to_csv3(col_sep: "\t") } 
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:repairdate, :code, :name, :parent_id, :lclass, :typename, :allocatable, :occupied, :staffadmin_id, :staff_name, :ancestry, :parent_code, damages_attributes: [:id, :description,:reported_on,:document_id])
    end
end