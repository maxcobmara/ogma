class Staff::AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy] 
 
  # GET /attendances
  # GET /attendances.xml
  def index
   # @attendances = Attendance.all
   @attendances = Attendance.with_permissions_to(:index).find(:all, :order => 'attdate DESC, id', :limit => 50)
   @mylate_attendances = Attendance.find_mylate
   @approvelate_attendances = Attendance.find_approvelate
   
   #@attendance_attdate = @attendances.group_by { |t| t.attdate.beginning_of_day }
  
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attendances }
    end
  end

  # GET /attendances/1
  # GET /attendances/1.xml
  def show
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attendance }
    end
  end

  # GET /attendances/new
  # GET /attendances/new.xml
  def new
    @attendance = Attendance.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attendance }
    end
  end

  # GET /attendances/1/edit
  def edit
    @attendance = Attendance.find(params[:id])
  end

  # POST /attendances
  # POST /attendances.xml
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
	format.html { redirect_to(staff_attendance_path(@attendance), :notice => (t 'attendance.title')+(t 'actions.created'))}
        format.xml  { render :xml => @attendance, :status => :created, :location => @attendance }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attendances/1
  # PUT /attendances/1.xml
  def update
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      if @attendance.update(attendance_params)
	format.html { redirect_to(staff_attendance_path(@attendance), :notice => (t 'attendance.title')+(t 'actions.updated'))}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attendance.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def approve
    @attendance = Attendance.find(params[:id])
  end
  
  

  # DELETE /attendances/1
  # DELETE /attendances/1.xml
  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to(attendances_url) }
      format.xml  { head :ok }
    end
  end
end

  
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attendance_params
      params.require(:attendance).permit(:staff_id, :attdate, :time_in, :time_out, :reason, :approve_id, :approvestatus)
    end