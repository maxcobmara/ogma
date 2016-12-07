class Staff::StaffsController < ApplicationController
  filter_access_to :index, :new, :create, :staff_list, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :borang_maklumat_staff, :attribute_check => true
  
  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  # GET /staffs
  # GET /staffs.json
  def index
    @search = Staff.search(params[:q])
    @staffs = @search.result.includes(:positions)
    @staffs = @staffs.page(params[:page]||1)
    @infos = @staffs
  end

  def auto_complete
    @staffs = Staff.order(:icno).where("icno like ?", "#{params[:term]}")
    render json: @staffs.map(&:icno)
  end
  
  # GET /staffs/1
  # GET /staffs/1.json
  def show
  end

  # GET /staffs/new
  def new
    @info = Staff.new
    @info.vehicles.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @info }
    end
  end

  # GET /staffs/1/edit
  def edit
    @info = Staff.find(params[:id])
    @info.vehicles.build if (@info.vehicles && @info.vehicles.count==0) || @info.vehicles[0].nil?
    @info.shift_histories.build if @info.staff_shift_id!=nil
  end

  # POST /staffs
  # POST /staffs.json
 def create
  @info = Staff.new(staff_params)
  respond_to do |format|
    if @info.save
      format.html { redirect_to staff_infos_path, notice: (t 'staff.title')+(t 'actions.created')}
      format.json { render action: 'show', status: :created, location: @info }
    else
      format.html { render action: 'new' }
      format.json { render json: @info.errors, status: :unprocessable_entity }
    end
  end
end

  # PATCH/PUT /staffs/1
  # PATCH/PUT /staffs/1.json
  def update
    @info = Staff.find(params[:id])
    c_shift = params[:staff][:staff_shift_id]
    if params[:staff][:shift_histories_attributes]
      s_shift = params[:staff][:shift_histories_attributes]["#{@info.shift_histories.count}"][:shift_id]
      new_ddate= params[:staff][:shift_histories_attributes]["#{@info.shift_histories.count}"][:deactivate_date]
      @info.create_shift_history_nodate(s_shift, c_shift, new_ddate) if (c_shift!=s_shift) && new_ddate==""
    end
    respond_to do |format|
      if @info.update(staff_params)
        format.html { redirect_to staff_info_path, notice: (t 'staff.title')+(t 'actions.updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffs/1
  # DELETE /staffs/1.json
  def destroy
    @staff.destroy
    respond_to do |format|
      format.html { redirect_to staff_infos_path }
      format.json { head :no_content }
    end
  end

  def borang_maklumat_staff

    @staff = Staff.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Borang_maklumat_staffPdf.new(@staff, view_context, current_user.college)
        send_data pdf.render, filename: "borang_maklumat_staff-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

 def staff_list
    @search = Staff.search(params[:q])
    @staffs = @search.result.includes(:positions)
    @infos=@staffs
    respond_to do |format|
      format.pdf do
        pdf = Staff_listPdf.new(@infos, view_context, current_user.college)
        send_data pdf.render, filename: "staff_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staff
      @staff = Staff.find(params[:id])
      @info = @staff
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_params
      params.require(:staff).permit(:icno, :name, :code, :fileno, :coemail, :cobirthdt, :thumb_id, :starting_salary, :current_salary, :allowance, :salary_no, :transportclass_id, :addr, :appointby, :appointdt, :appointstatus, :att_colour, :birthcertno, :bloodtype, :confirmdt, :cooftelext , :cooftelno, :country_cd, :country_id, :created_at, :employscheme, :employstatus, :gender, :kwspcode , :mrtlstatuscd, :pension_confirm_date, :pensiondt,:pensionstat, :phonecell, :phonehome, :photo, :posconfirmdate, :position_old, :poskod_id, :promotion_date, :race, :reconfirmation_date, :religion, :schemedt, :staff_shift_id, :staffgrade_id, :starting_salary, :statecd, :svchead, :svctype, :taxcode, :time_group_id, :titlecd_id, :to_current_grade_date, :uniformstat, :updated_at, :wealth_decleration_date, :college_id, {:data=>[]}, :rank_id, qualifications_attributes: [:id, :_destroy, :level_id, :qname, :institute_id, :institute],kins_attributes: [:id,:destroy, :kintype_id,  :name, :mykadno, :phone, :profession, :kinaddr],vehicles_attributes: [:id, :_destroy, :type_model, :reg_no, :cylinder_capacity], mycpds_attributes: [:id, :_destroy, :staff_id, :cpd_year, :cpd_value],shift_histories_attributes: [:shift_id, :deactivate_date] ) #without id & destroy
    end
end

#  bank                    :string(255)
#  bankaccno               :string(255)
#  bankacctype             :string(255)
#  transportclass_id       :string(255)



