class Staff::LeaveforstaffsController < ApplicationController
  before_action :set_leaveforstaff, only: [:show, :edit, :update, :destroy]
  
  def index
 @leaveforstaffs = Leaveforstaff.all    
  end
  def show
    @leaveforstaff = Leaveforstaff.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @leaveforstaff }
    end
  end
  
  def edit
    @leaveforstaff = Leaveforstaff.find(params[:id])
  end
  
  def update
    @leaveforstaff = Leaveforstaff.find(params[:id])

    respond_to do |format|
      if @leaveforstaff.update(leaveforstaff_params)
        format.html { redirect_to(params[:redirect_location], :notice =>t('actions.updated')) }
        format.xml  { head :ok }
      
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @leaveforstaff.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def create
      @leaveforstaff = Leaveforstaff.new(leaveforstaff_params)

      respond_to do |format|
        if @leaveforstaff.save
          flash[:notice] = 'Leaveforstaff was successfully created.'
          format.html { redirect_to(staff_leaveforstaff_path(@leaveforstaff)) }
          format.xml  { render :xml => @leaveforstaff, :status => :created, :location => @leaveforstaff }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @leaveforstaff.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /leaveforstaffs/1
    # PUT /leaveforstaffs/1.xml
    
    def destroy
      @leaveforstaff = Leaveforstaff.find(params[:id])
      @leaveforstaff.destroy

      respond_to do |format|
        format.html { redirect_to(staff_leaveforstaffs_url) }
        format.xml  { head :ok }
      end
    end
  
  def new
    @leaveforstaff = Leaveforstaff.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @leaveforstaff }
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaveforstaff
      @leaveforstaffs = Leaveforstaff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaveforstaff_params
      params.require(:leaveforstaff).permit(:staff_id, :leavetype, :leavestartdate, :leavenddate, :reason, :notes, :approval1)
    end
end