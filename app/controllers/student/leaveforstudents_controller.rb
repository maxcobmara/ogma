class Student::LeaveforstudentsController < ApplicationController
  filter_access_to :index, :new, :create, :slip_pengesahan_cuti_pelajar, :studentleave_report, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :new_multiple, :new_multiple_intake, :attribute_check => true
  before_action :set_leaveforstudent, only: [:show, :edit, :update, :destroy]

  def index
    #@leaveforstudent = Leaveforstudent.all
    @search = Leaveforstudent.search(params[:q])
    #@leaveforstudent = @search.result
    @leaveforstudent = @search.result.search2(@current_user)
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
  
  def approve_coordinator
    @leaveforstudent = Leaveforstudent.find(params[:id])
  end
  
  def approve_warden
    @leaveforstudent = Leaveforstudent.find(params[:id])
  end
  
  def slip_pengesahan_cuti_pelajar

    @leaveforstudent = Leaveforstudent.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Slip_pengesahan_cuti_pelajarPdf.new(@leaveforstudent, view_context)
        send_data pdf.render, filename: "slip_pengesahan_cuti_pelajar-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def studentleave_report
    @search = Leaveforstudent.search(params[:q])
    @leaveforstudents = @search.result
    @expired_wc=[]
    @leaveforstudents.each_with_index do |leaveforstudent, ind|
      @expired_wc << ind+1 if leaveforstudent.studentsubmit==true && leaveforstudent.leave_startdate < Date.tomorrow && (leaveforstudent.approved2==nil || leaveforstudent.approved==nil)
    end
    respond_to do |format|
       format.pdf do
         pdf = Studentleave_reportPdf.new(@leaveforstudents, @expired_wc, view_context)
         send_data pdf.render, filename: "studentleave_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leaveforstudent
      @leaveforstudent = Leaveforstudent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leaveforstudent_params
      params.require(:leaveforstudent).permit(:student_id, :leavetype, :requestdate, :reason, :address, :telno, :leave_startdate, :leave_enddate, :studentsubmit, :approved, :staff_id, :approvedate,
                                              :notes, :approved2, :staff_id2, :approvedate2)
    end
end

