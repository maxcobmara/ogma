class Staff::StaffShiftsController < ApplicationController
  filter_resource_access
  before_action :set_staff_shift, only: [:show, :edit, :update, :destroy]
  # GET /staff_shifts
  # GET /staff_shifts.xml
  def index
    @search = StaffShift.search(params[:q])
    @staff_shifts = @search.result
    @staff_shifts = @staff_shifts.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @staff_shifts }
    end
  end

  def new
    @staff_shift=StaffShift.new
  end
  
  def create
    @staff_shift=StaffShift.new(staff_shift_params)
    respond_to do |format|
      if @staff_shift.save
        format.html { redirect_to staff_staff_shift_path(@staff_shift), :notice =>t('staff.staff_shifts.title')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff_shift.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /staff_shifts/1/edit
  def edit
    @staff_shift = StaffShift.find(params[:id])
  end

  # PUT /staff_shifts/1
  # PUT /staff_shifts/1.xml
  def update
    @staff_shift = StaffShift.find(params[:id])

    respond_to do |format|
      if @staff_shift.update(staff_shift_params)
        format.html { redirect_to staff_staff_shift_path(@staff_shift), :notice =>t('staff.staff_shifts.title')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @staff_shift.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @staff_shift = StaffShift.find(params[:id])
  end
  
  def destroy
    @staff_shift = StaffShift.find(params[:id])
    @staff_shift.destroy

    respond_to do |format|
      format.html { redirect_to(staff_staff_shifts_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_staff_shift
      @staff_shift = StaffShift.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staff_shift_params
      params.require(:staff_shift).permit(:name, :start_at, :end_at, :college_id, {:data => []})
    end

end
