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
  
  def create
      @leaveforstaffs = Leaveforstaff.new(leaveforstaff_params)

      respond_to do |format|
        if @leaveforstaffs.save
          flash[:notice] = 'Leaveforstaff was successfully created.'
          format.html { redirect_to(@leaveforstaffs) }
          format.xml  { render :xml => @leaveforstaffs, :status => :created, :location => @leaveforstaffs }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @leaveforstaffs.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /leaveforstaffs/1
    # PUT /leaveforstaffs/1.xml
  
  def new
    @leaveforstaffs = Leaveforstaff.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @leaveforstaffs }
  end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaveforstaff
      @leaveforstaffs = Leaveforstaff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaveforstaff_params
      params.require(:leaveforstaff).permit(:staff_id, :leavetype, :reason, :notes, :approval1)
    end
end