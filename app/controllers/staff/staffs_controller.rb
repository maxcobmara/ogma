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
  end

  # GET /staffs/1/edit
  def edit
  end

  # POST /staffs
  # POST /staffs.json
  def create
    @staff = Staff.new(staff_params)

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
    respond_to do |format|
      if @staff.update(staff_params)
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
      params.require(:staff).permit(:icno, :name, :code, :fileno, :coemail, :cobirthdt, :thumb_id)
    end
end
