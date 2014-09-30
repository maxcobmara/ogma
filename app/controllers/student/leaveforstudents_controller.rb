class Student::LeaveforstudentsController < ApplicationController
  before_action :set_leaveforstaff, only: [:show, :edit, :update, :destroy]
  
  def index
 @leaveforstudents = Leaveforstudent.all    
  end
  
  def show
  end
  
  def new
    @leaveforstudents = Leaveforstudent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @leaveforstudents }
  end
end

  #private
    # Use callbacks to share common setup or constraints between actions.
    #def set_leaveforstudent
      #@leaveforstudent = Leaveforstudent.find(params[:id])
    #end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def leaveforstudent_params
      #params.require(:leaveforstudent).permit(:student_id, :leavetype, :reason, :notes, :approval1)
    #end
end