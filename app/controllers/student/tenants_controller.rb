class Student::TenantsController < ApplicationController
  filter_access_to :index,:index_staff, :reports, :statistics, :tenant_report, :tenant_report_staff, :return_key, :return_key2, :room_map, :room_map2, :new, :create,  :laporan_penginapan, :laporan_penginapan2, :census, :census_level, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_tenant, only: [:show, :edit, :update, :destroy]
  before_action :set_index, only: [:index, :tenant_report] #2ndOct2017
  before_action :set_index_staff, only: [:index_staff, :tenant_report_staff] #2ndOct2017
  before_action :set_statistics_reports, only: [:statistics, :reports, :census, :census_level, :laporan_penginapan] #2nd-4thOct2017
  
  def index
#     rev 2ndOct2017
#     #@search = Tenant.where("student_id IS NOT NULL").search(params[:q])
#     @search = Tenant.search(params[:q]) #NOTE: To match with room map, statistic (by programme) & census_level (+report)
#     if params[:q]
#       #move searches here
#     end
    
    @search.keyreturned_present != nil #unless params[:q]
    @search.force_vacate_true = false #unless params[:q]
    @search.sorts = 'location_combo_code asc' if @search.sorts.empty?
    @tenants_all = @search.result.where('student_id is not null')
    @tenants = @tenants_all.page(params[:page]||1)  
    respond_to do |format|
      format.html
      #format.xls - temp hide until resolve - 'general i/o error'
      format.csv { send_data @tenants_all.to_csv }
      format.xls { send_data @tenants_all.to_csv(col_sep: "\t") } 
    end
  end
  
  def index_staff
#     rev 2ndOct2017
#     @search = Tenant.search(params[:q]) #NOTE: To match with room map, statistic (by programme) & census_level (+report)
#     if params[:q]
#       #move searches here
#     end
    
    @search.keyreturned_present != nil #unless params[:q]
    @search.force_vacate_true = false #unless params[:q]
    @search.sorts = 'location_combo_code asc' if @search.sorts.empty?
    @tenants_all = @search.result.where('staff_id is not null')
    @tenants = @tenants_all.page(params[:page]||1)
  end

  #Statistic (by level) & Census(links only)
  def reports
    #Listing of all levels in all blocks
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    roots = []
    @places.each do |place|
     roots << place.root
    end
    @residentials = roots.uniq
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    
    #ori be4 2ndOct2017
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    @current_tenants = @tenants.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    
    @occupied_locations = @current_tenants.pluck(:location_id)
    
    #Excel - Statistic by level (of selected block) - moved to LOCATION module - statistic_level
  end
  
  #Census by level
  #fr menu - 'Statistik Penginapan & Bancian Penghuni Mengikut Aras' / pautan Bancian (X penghuni)
  def census_level
    @floor_id = params[:id]
    @floor=Location.find(@floor_id) #103, 1181
    @all_beds_single=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).sort_by{|y|y.combo_code}
    #@all_rooms=Location.find(params[:id]).descendants.where('typename = ?',6) #NOTE : error - not precise!
    @all_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
    @damaged_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).where(occupied: true).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    
    #ori be4 3rdOct2017
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    @current_tenants = @tenants.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    
    @tenantbed_per_level=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).joins(:tenants).where("tenants.id" => @current_tenants)
    @occupied_rooms= @tenantbed_per_level.pluck(:combo_code).group_by{|x|x[0, x.size-2]}

    #Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).where('id iN(?)', @current_tenants.pluck(:location_id)).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
    #must not be sorted
    #building.descendants.where(typename: [2,8]).joins(:tenants).where("tenants.id" => @current_tenants)
    
    #Excel - Census by level - moved to LOCATION module - census_level2
  end

  def room_map
    @residentials = Location.where(lclass: 4).order(combo_code: :asc)
    #sets div size to fit no of buildings
    @div_width = 90/@residentials.count
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    @occupied_locations = @current_tenants.pluck(:location_id)
  end
  
  #For Staff Quarters - start
  def room_map2
    @places = Location.where(typename: 1)
    roots = []
    @places.each do |place|
     roots << place.root
    end
    @residentials = roots.uniq  #Location.where('lclass=? AND id IN (?)',1,quarters).order(combo_code: :asc)
    #sets div size to fit no of buildings
    @div_width = 90/@residentials.count
    staff_house_ids = Location.where(typename: 1).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, staff_house_ids)
    @occupied_locations = @current_tenants.pluck(:location_id)
  end
  #For Staff Quarters - end

  def statistics
    @locations = Location.where('typename IN (?)', [2,8])
    @female_student_beds  = @locations.where('typename = ?', 2)
    @male_student_beds    = @locations.where('typename = ?', 8)
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    
    #ori be4 2ndOct2017 - @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    @current_tenants = @tenants.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    
    @occupied_locations = @current_tenants.pluck(:location_id)
    
    #All Rooms
     @af_bedcode = @female_student_beds.pluck(:combo_code)
     @am_bedcode = @male_student_beds.pluck(:combo_code)
     @am_rooms = @am_bedcode.group_by{|x|x[0, x.size-2]} #block A  {"HA-01-01"=>["HA-01-01-A", "HA-01-01-B"]} - group by male rooms (Block A)
     @af_rooms = @af_bedcode.group_by{|x|x[0, x.size-2]}   #block B & C {"HB-01-01"=>["HB-01-01-A", "HB-01-01-B"], "HC-01-01"=>["HC-01-01-A", "HC-01-01-B"]}
#     @bedF_B = @af_bedcode.group_by{|x|x[1,1]}["B"]     #bed by block {"B"=>["HB-01", "HB-01", "HB-02"], "C"=>["HC-01"]}
#     @bedF_C = @af_bedcode.group_by{|x|x[1,1]}["C"]
#     @roomF_B = @bedF_B.group_by{|x|x[0, x.size-2]}
#     @roomF_C = @bedF_C.group_by{|x|x[0, x.size-2]}

    #Occupied Rooms
     @of_bedcode = @female_student_beds.joins(:tenants).where("tenants.id" => @current_tenants).pluck(:combo_code)
     @om_bedcode = @male_student_beds.joins(:tenants).where("tenants.id" => @current_tenants).pluck(:combo_code)
     @of_rooms = @of_bedcode.group_by{|x|x[0, x.size-2]}
     @om_rooms = @om_bedcode.group_by{|x|x[0, x.size-2]}

    #Damaged Rooms
     @df_bedcode = @female_student_beds.where(occupied: true).pluck(:combo_code)
     @dm_bedcode = @male_student_beds.where(occupied: true).pluck(:combo_code)
     @df_rooms = @df_bedcode.group_by{|x|x[0, x.size-2]}
     @dm_rooms = @dm_bedcode.group_by{|x|x[0, x.size-2]}

    #For Statistics by Programme
    @places = Location.where('typename = ? OR typename =?', 2, 8)
    roots = []
    @places.each do |place|
     roots << place.root
    end
    @residentials = roots.uniq
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true) - duplicate
    @occupied_locations = @current_tenants.pluck(:location_id)
  end
  
  def return_key
    if params[:search] && params[:search][:student_icno_location].present?
      params[:id]=nil
      @student_ic = params[:search][:student_icno_location]
      splitter = @student_ic.split(" ")
      @ic_only = splitter[0]
      @combo_code = splitter[(splitter.size-1)]
      @location = Location.where('combo_code ILIKE(?)', "%#{@combo_code}%").first
      #@selected_student = Student.where("icno = ?", "#{@student_ic}").first
      if @location
        @my_room = Tenant.where(student_id: Student.where("icno = ?", "#{@ic_only}").first, location_id: @location.id).first
      else
        @my_room = Tenant.where(student_id: Student.where("icno = ?", "#{@ic_only}").first).first
      end
    elsif params[:id]
      @tenant_id = params[:id]
      @my_room = Tenant.where(id: @tenant_id).first
    end
    @tenant = @my_room
  end
  
  def return_key2
    if params[:search] && params[:search][:staff_icno_location].present?
      params[:id]=nil
      @staff_ic = params[:search][:staff_icno_location]
      splitter =  @staff_ic.split(" ")
      @ic_only = splitter[0]
      @combo_code = splitter[(splitter.size-1)]
      @location =  Location.where('combo_code ILIKE(?)', "%#{@combo_code}%").first
      if @location
        @my_room = Tenant.where(staff_id: Staff.where("icno = ?", "#{@ic_only}").first, location_id: @location.id).first 
      else
        @my_room = Tenant.where(staff_id: Staff.where("icno = ?", "#{@ic_only}").first).first
      end
    elsif params[:id]
      @tenant_id = params[:id]
      @my_room = Tenant.where(id: @tenant_id).first
    end
    @tenant = @my_room
  end

  def new
    @current_tenant_ids = Tenant.where(:keyreturned => nil).where(:force_vacate => false).pluck(:student_id)
    @potential1=Student.where(gender: 1).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
    @potential2=Student.where(gender: 2).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
    @potential3=Staff.pluck(:id)-Tenant.where(:keyreturned => nil).where(:force_vacate => false).pluck(:staff_id)
    @tenant = Tenant.new(:location_id => params[:location_id])
  end

  def edit
    @current_tenant_ids = Tenant.where(:keyreturned => nil).where(:force_vacate => false).pluck(:student_id)
    @potential1=Student.where(gender: 1).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
    @potential2=Student.where(gender: 2).where("end_training > ?", Date.today).pluck(:id)-@current_tenant_ids
    @potential3=Staff.pluck(:id)-Tenant.where(:keyreturned => nil).where(:force_vacate => false).pluck(:staff_id)
  end

  def create
    @tenant = Tenant.new(tenant_params)
    respond_to do |format|
      if @tenant.save
        if [2,8].include?@tenant.location.typename
          flash[:notice] = (t 'student.tenant.title')+(t 'actions.created')
        elsif @tenant.location.typename==1
          flash[:notice] = (t 'student.tenant.title2')+(t 'actions.created')
        end
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
         if [2,8].include?@tenant.location.typename
          flash[:notice] = (t 'student.tenant.title')+(t 'actions.updated') 
        elsif @tenant.location.typename==1
          flash[:notice] = (t 'student.tenant.title2')+(t 'actions.updated') 
        end
        format.html { redirect_to student_tenant_path(@tenant) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tenant.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end
  
  #PDF for census_level
  def census
     @floor=Location.find(params[:id]) #103, 1181
     @all_beds_single=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).sort_by{|y|y.combo_code}
     #@all_rooms=Location.find(params[:id]).descendants.where('typename = ?',6) #error - not precise
     @all_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
     @damaged_rooms=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).where(occupied: true).pluck(:combo_code).group_by{|x|x[0, x.size-2]}
     #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
     student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
     
     #ori be4 3rdOct2017
     #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
     @current_tenants = @tenants.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
     
     @tenantbed_per_level=Location.find(params[:id]).descendants.where('typename = ? OR typename =?', 2, 8).joins(:tenants).where("tenants.id" => @current_tenants)
     @occupied_rooms= @tenantbed_per_level.pluck(:combo_code).group_by{|x|x[0, x.size-2]}

     @all_tenants_wstudent = @current_tenants.joins(:location).where('location_id IN(?) and student_id IN(?)', @tenantbed_per_level.pluck(:id), Student.all.pluck(:id))
     @students_prog = Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id)).group_by{|j|j.course_id}
     @all_tenants_wostudent = @current_tenants.joins(:location).where('location_id IN(?) and (student_id is null OR student_id NOT IN(?))', @tenantbed_per_level.pluck(:id), Student.all.pluck(:id))
    
     ab=Student.where('id IN (?)', @all_tenants_wstudent.pluck(:student_id))
    respond_to do |format|
      format.pdf do
	pdf = CensusStudentTenantsPdf.new(@all_beds_single,@all_rooms.count, @damaged_rooms.count,@occupied_rooms.count, @students_prog, @all_tenants_wstudent.count, ab, @all_tenants_wostudent.count, @tenantbed_per_level.count, view_context, current_user)
        send_data pdf.render, filename: "census",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  #PDF for Index - student residence
  def tenant_report
#     rev 2ndOct2017 - @search = Tenant.search(params[:q]) #NOTE: To match with room map, statistic (by programme) & census_level (+report)
    @search.keyreturned_present != nil #unless params[:q]
    @search.force_vacate_true = false #unless params[:q]
    @search.sorts = 'location_combo_code asc' if @search.sorts.empty?
    @tenants = @search.result.where('student_id is not null')
    respond_to do |format|
       format.pdf do
         pdf = Tenant_reportPdf.new(@tenants, view_context, current_user.college)
                   send_data pdf.render, filename: "tenant_report-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end
  
  #PDF for Index - staff residence
  def tenant_report_staff
#     rev 2ndOct2017 - @search = Tenant.search(params[:q]) 
    @search.keyreturned_present != nil #unless params[:q]
    @search.force_vacate_true = false #unless params[:q]
    @search.sorts = 'location_combo_code asc' if @search.sorts.empty?
    @tenants = @search.result.where('staff_id is not null')
    respond_to do |format|
       format.pdf do
         pdf = Tenant_report_staffPdf.new(@tenants, view_context, current_user.college)
                   send_data pdf.render, filename: "tenant_report-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end
  
  #PDF for Reports (Statistik Penginapan-level listing)
  def laporan_penginapan
    buildingname = params[:buildingname]
    @residential = Location.where('name LIKE (?) and lclass=?', "#{buildingname}", 4).first
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    
    #ori be4 4thOct2017
    #@current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    @current_tenants = @tenants.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    
    respond_to do |format|
       format.pdf do
         pdf = Laporan_penginapanPdf.new(@residential, @current_tenants, view_context, current_user.college)
                   send_data pdf.render, filename: "laporan_penginapan-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end

  #PDF for Statistic (general) - room status(part of laporan/statistik penginapan) & tenant programme 
  #-- fr menu, Statistik Umum / Blok / Program - 'Statistik Penempatan Pelatih'
  def laporan_penginapan2
    blockid= params[:blockid]
    @residentials = Location.find(blockid).descendants.where('typename = ? OR typename =?', 2, 8)    #beds
    #@current_tenants=Tenant.where("keyreturned IS ? AND force_vacate != ?", nil, true)
    student_bed_ids = Location.where(typename: [2,8]).pluck(:id)
    @current_tenants = Tenant.where("keyreturned IS ? AND force_vacate != ? and location_id IN(?)", nil, true, student_bed_ids)
    respond_to do |format|
       format.pdf do
         pdf = Laporan_penginapan2Pdf.new(@residentials, @current_tenants, view_context, current_user.college)
                   send_data pdf.render, filename: "laporan_penginapan-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end
  
  #PDF for Show - Tenant
  def tenant_form
    @tenant = Tenant.find(params[:id])
    respond_to do |format|
       format.pdf do
         pdf = Tenant_formPdf.new(@tenant, view_context, current_user)
                   send_data pdf.render, filename: "tenant_report-{Date.today}",
                   type: "application/pdf",
                   disposition: "inline"
       end
     end
  end

  def destroy
    locationtyp=@tenant.location.typename
    @tenant.destroy
    respond_to do |format|
      if locationtyp==1
        format.html { redirect_to index_staff_student_tenants_path } #room_map2
      else
        format.html { redirect_to student_tenants_path } #room_map
      end
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tenant
      @tenant = Tenant.find(params[:id])
    end
    
    def set_index
      roles=current_user.roles.map(&:authname)
      if roles.include?('developer') || (roles.include?('administration') && User.icms_acct.include?(current_user.id))
        @search = Tenant.search(params[:q])
      else
        @search = Tenant.isstudents.search(params[:q]) #NOTE: To match with room map, statistic (by programme) & census_level (+report)
      end
    end
    
    def set_index_staff
      roles=current_user.roles.map(&:authname)
      if roles.include?('developer') || (roles.include?('administration') && User.icms_acct.include?(current_user.id))
        @search = Tenant.search(params[:q])
      else
        @search = Tenant.isstaffs.search(params[:q]) #NOTE: To match with room map, statistic (by programme) & census_level (+report)
      end
    end
    
    def set_statistics_reports
      roles=current_user.roles.map(&:authname)
      if roles.include?('developer') || (roles.include?('administration') && User.icms_acct.include?(current_user.id))
        @tenants=Tenant.all
      else
	@tenants=Tenant.isstudents
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tenant_params
      params.require(:tenant).permit(:location_id, :staff_id, :student_id, :keyaccept, :keyexpectedreturn, :keyreturned, :force_vacate, :student_icno, :staff_icno,:staff_icno_location, :student_icno_location, :total_keys, :deposit, :meal_requirement, :college_id, {:data => []}, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id])
    end

end
