class Staff::LeaveforstaffsController < ApplicationController
  before_action :set_leaveforstaff, only: [:show, :edit, :update, :destroy]
  
  def index
 @leaveforstaffs = Leaveforstaff.all    
  end
  def show
  end
  
  def create
  end
  
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
      @leaveforstaff = Leaveforstaff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaveforstaff_params
      params.require(:leaveforstaff).permit(:staff_id, :leavetype, :reason, :notes, :approval1)
    end
end