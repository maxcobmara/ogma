 class Staff::TravelRequestsController < ApplicationController
   filter_access_to :index, :new, :create, :travel_log_index, :travelrequest_list, :travellog_list, :attribute_check => false
   filter_access_to :show, :edit, :update, :destroy, :travel_log, :approval, :status_movement, :attribute_check => true
   #before_filter :set_current_user
   before_action :set_travel_request, only: [:show, :edit, :update, :destroy]
   before_action :set_admin, only: [:new, :edit]
    
  # GET /travel_requests
  # GET /travel_requests.xml
  def index
    @search = TravelRequest.search(params[:q])
    @for_approvals = @search.result.in_need_of_approval(current_user.userable.id)
    @travel_requests = @search.result.my_travel_requests(current_user.userable.id)
    #@for_approvals = @for_approvals.page(params[:page]||1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @travel_requests }
    end
  end

  # GET /travel_requests/1
  # GET /travel_requests/1.xml
  def show
    @travel_request = TravelRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @travel_request }
    end
  end

  # GET /travel_requests/new
  # GET /travel_requests/new.xml
  def new
    @travel_request = TravelRequest.new
    @generated_code = SecureRandom.hex 8
    respond_to do |format|
      if @current_user.userable.positions!=nil && @current_user.userable.positions.first.unit!=""
        format.html # new.html.erb
        format.xml  { render :xml => @travel_request }
      else
        format.html {redirect_to staff_travel_requests_url, :notice => t('positions_required')+t('staff.travel_request.title')+t('inc_unitname')}
        format.xml  { render :xml => @travel_request }
      end
    end
  end

  # GET /travel_requests/1/edit
  def edit
    @travel_request = TravelRequest.find(params[:id])
  end

  # POST /travel_requests
  # POST /travel_requests.xml
  def create
    @travel_request = TravelRequest.new(travel_request_params)
    @generated_code = params[:travel_request][:code]

    respond_to do |format|
      if @travel_request.save
        format.html { redirect_to(staff_travel_request_path(@travel_request), :notice =>t('staff.travel_request.title')+t('actions.created')) }
        format.xml  { render :xml => @travel_request, :status => :created, :location => @travel_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @travel_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /travel_requests/1
  # PUT /travel_requests/1.xml
  def update
    #raise params.inspect
    @travel_request = TravelRequest.find(params[:id])

    respond_to do |format|
      if @travel_request.update(travel_request_params)
        format.html { redirect_to(params[:redirect_location], :notice =>t('staff.travel_request.title')+t('actions.updated')) }
        format.xml  { head :ok }
      
      else
	if params[:task] && params[:task]=="1"
	  format.html {render :action => "travel_log"}
	  format.xml  { render :xml => @travel_request.errors, :status => :unprocessable_entity }
	elsif params[:task] && params[:task]=="2"
# 	  w = []
# 	  @travel_request.errors.each do |k,v|
# 	    w << v
# 	  end
# 	  flash[:notice]= "whhh"+w.to_s
	   format.html {render :action => "approval"}
	   format.xml  { render :xml => @travel_request.errors, :status => :unprocessable_entity }
	else
          format.html { render :action => "edit" }
	  format.xml  { render :xml => @travel_request.errors, :status => :unprocessable_entity }
	end
        format.xml  { render :xml => @travel_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /travel_requests/1
  # DELETE /travel_requests/1.xml
  def destroy
    @travel_request = TravelRequest.find(params[:id])
    @travel_request.destroy

    respond_to do |format|
      format.html { redirect_to(staff_travel_requests_url) }
      format.xml  { head :ok }
    end
  end
  
  def travel_log_index
    @search = TravelRequest.search(params[:q])
    @my_approved_requests = @search.result.where('staff_id =? AND hod_accept=?', current_user.userable.id, true)
    @my_approved_requests = @my_approved_requests.page(params[:page]||1)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @approved }
    end
  end
  
  def travel_log
     #@travel_log = TravelRequest.find(params[:id])
    # @travel_request =  @travel_log
    @travel_request = TravelRequest.find(params[:id])
    @travel_request.travel_claim_logs.build
  end
  
  def approval
     @travel_request = TravelRequest.find(params[:id])
  end
  
  def status_movement
    @travel_request = TravelRequest.find(params[:id])
    
    respond_to do |format|
       format.pdf do
         pdf = Status_movementPdf.new(@travel_request, view_context)
         send_data pdf.render, filename: "status_movement-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
  
  def travelrequest_list
    @search = TravelRequest.search(params[:q])
    @for_approvals = @search.result.in_need_of_approval(current_user.userable.id)
    @travel_requests = @search.result.my_travel_requests(current_user.userable.id)
    respond_to do |format|
      format.pdf do
        pdf = Travelrequest_listPdf.new(@for_approvals, @travel_requests, view_context, current_user.college)
        send_data pdf.render, filename: "travelrequest_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  def travellog_list
    @search = TravelRequest.search(params[:q])
    @my_approved_requests = @search.result.where('staff_id =? AND hod_accept=?', current_user.userable.id, true)
    respond_to do |format|
      format.pdf do
        pdf = Travellog_listPdf.new(@my_approved_requests, view_context, current_user.college)
        send_data pdf.render, filename: "travellog_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
  
  def set_travel_request
    @travel_request = TravelRequest.find(params[:id])
    @travel_log = @travel_request
  end
  
  def set_admin
      roles = current_user.roles.pluck(:authname)
      @is_admin = true if roles.include?("administration") || roles.include?("staff_leaves_module_admin") || roles.include?("staff_leaves_module_viewer") || roles.include?("staff_leaves_module_user")
    end
  
  def travel_request_params
    params.require(:travel_request).permit(:staff_id, :document_id, :staff_course_conducted_id, :destination, :depart_at, :return_at, :own_car, :own_car_notes, :dept_car, :others_car, :taxi, :bus, :train, :plane, :other, :other_desc, :is_submitted, :submitted_on, :replaced_by, :mileage, :mileage_replace, :hod_id, :hod_accept, :hod_accept_on, :travel_claim_id, :is_travel_log_complete, :log_mileage, :log_fare, :code, :others_car_notes, :college_id, {:data => []}, travel_claim_logs_attributes: [:id, :travel_request_id, :travel_on, :start_at, :finish_at, :destination, :mileage, :km_money, :checker, :checker_notes,:_destroy])
  end
  
end
