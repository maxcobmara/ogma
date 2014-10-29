class Staff::StaffsController < ApplicationController
  before_action :set_staff, only: [:show, :edit, :update, :destroy]

  # GET /staffs
  # GET /staffs.json
  def index
    @search = Staff.search(params[:q])
    @staffs = @search.result.includes(:positions)
    @staffs = @staffs.page(params[:page]||1)
    @infos = @staffs
  end

  # GET /staffs/1
  # GET /staffs/1.json
  def show
  end

  # GET /staffs/new
  def new
    @info = Staff.new
    @info.vehicles.build
  end

  # GET /staffs/1/edit
  def edit
    @info = Staff.find(params[:id])
    @info.vehicles.build if @info.vehicles && @info.vehicles.count==0
  end

  # POST /staffs
  # POST /staffs.json
  def create
    @info = Staff.new(staff_params)

    respond_to do |format|
      if @staff.save
        format.html { redirect_to @staff, notice: 'Staff was successfully created.' }
        format.json { render action: 'show', status: :created, location: @staff }
      else
        format.html { render action: 'new' }
        format.json { render json: @staff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffs/1
  # PATCH/PUT /staffs/1.json
  def update
    @info = Staff.find(params[:id])
    respond_to do |format|
      if @info.update(staff_params)
        format.html { redirect_to staff_info_path, notice: 'Staff was successfully updated.' }
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
      format.html { redirect_to staffs_url }
      format.json { head :no_content }
    end
  end

  def borang_maklumat_staff

    @staff = Staff.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Borang_maklumat_staffPdf.new(@staff, view_context)
        send_data pdf.render, filename: "borang_maklumat_staff-{Date.today}",
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
      params.require(:staff).permit(:icno, :name, :code, :fileno, :coemail, :cobirthdt, :thumb_id, :starting_salary, :current_salary, :transportclass_id, qualifications_attributes: [:id, :_destroy, :level_id, :qname, :institute_id, :institute],vehicles_attributes: [:id, :_destroy, :type_model, :reg_no, :cylinder_capacity] )
    end
end


# == Schema Information
#
# Table name: staffs
#
#  addr                    :string(255)
#  appointby               :string(255)
#  appointdt               :date
#  appointstatus           :string(255)
#  att_colour              :integer
#  bank                    :string(255)
#  bankaccno               :string(255)
#  bankacctype             :string(255)
#  birthcertno             :string(255)
#  bloodtype               :string(255)
#  cobirthdt               :date
#  code                    :string(255)
#  coemail                 :string(255)
#  confirmdt               :date
#  cooftelext              :string(255)
#  cooftelno               :string(255)
#  country_cd              :integer
#  country_id              :integer
#  created_at              :datetime
#  employscheme            :string(255)
#  employstatus            :integer
#  fileno                  :string(255)
#  gender                  :integer
#  icno                    :string(255)
#  id                      :integer          not null, primary key
#  kwspcode                :string(255)
#  mrtlstatuscd            :integer
#  name                    :string(255)
#  pension_confirm_date    :date
#  pensiondt               :date
#  pensionstat             :string(255)
#  phonecell               :string(255)
#  phonehome               :string(255)
#  photo_content_type      :string(255)
#  photo_file_name         :string(255)
#  photo_file_size         :integer
#  photo_updated_at        :datetime
#  posconfirmdate          :date
#  position_old            :integer
#  poskod_id               :integer
#  promotion_date          :date
#  race                    :integer
#  reconfirmation_date     :date
#  religion                :integer
#  schemedt                :date
#  staff_shift_id          :integer
#  staffgrade_id           :integer
#  starting_salary         :decimal(, )
#  statecd                 :integer
#  svchead                 :string(255)
#  svctype                 :string(255)
#  taxcode                 :string(255)
#  thumb_id                :integer
#  time_group_id           :integer
#  titlecd_id              :integer
#  to_current_grade_date   :date
#  transportclass_id       :string(255)
#  uniformstat             :string(255)
#  updated_at              :datetime
#  wealth_decleration_date :date
#
