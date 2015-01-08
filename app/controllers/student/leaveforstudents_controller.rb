class Student::LeaveforstudentsController < ApplicationController
  before_action :set_leaveforstudent, only: [:show, :edit, :update, :destroy]

  def index
    #@leaveforstudent = Leaveforstudent.all
    @search = Leaveforstudent.search(params[:q])
    @leaveforstudent = @search.result
    @leaveforstudent = @leaveforstudent.page(params[:page]||1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @leaveforstudents }
    end
  end

  # GET /leaveforstudents/1
  # GET /leaveforstudents/1.xml
  def show
    @leaveforstudent = Leaveforstudent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @leaveforstudent }
    end
  end

  # GET /leaveforstudents/new
  # GET /leaveforstudents/new.xml
  def new
    @leaveforstudent = Leaveforstudent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @leaveforstudent }
    end
  end

  # GET /leaveforstudents/1/edit
  def edit
    @leaveforstudent = Leaveforstudent.find(params[:id])
  end

  # POST /leaveforstudents
  # POST /leaveforstudents.xml
  def create
    @leaveforstudent = Leaveforstudent.new(leaveforstudent_params)

    respond_to do |format|
      if @leaveforstudent.save
        flash[:notice] = 'Leaveforstudent was successfully created.'
        format.html { redirect_to student_leaveforstudents_path }
        format.xml  { render :xml => @leaveforstudent, :status => :created, :location => @leaveforstudent }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @leaveforstudent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /leaveforstudents/1
  # PUT /leaveforstudents/1.xml
  def update
    @leaveforstudent = Leaveforstudent.find(params[:id])

    respond_to do |format|
      if @leaveforstudent.update_attributes(leaveforstudent_params)
        flash[:notice] = 'Leaveforstudent was successfully updated.'
        format.html { redirect_to student_leaveforstudents_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @leaveforstudent.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /leaveforstudents/1
  # DELETE /leaveforstudents/1.xml
  def destroy
    @leaveforstudent = Leaveforstudent.find(params[:id])
    @leaveforstudent.destroy

    respond_to do |format|
      format.html { redirect_to student_leaveforstudents_path }
      format.xml  { head :ok }
    end
  end
  
  def approve
    @leaveforstudent = Leaveforstudent.find(params[:id])
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaveforstudent
      @leaveforstudent = Leaveforstudent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaveforstudent_params
      params.require(:leaveforstudent).permit(:student_id, :leavetype, :requestdate, :reason, :address, :telno, :leave_startdate, :leave_enddate, :studentsubmit, :approved, :staff_id, :staff_id, :approvedate)
    end
end

