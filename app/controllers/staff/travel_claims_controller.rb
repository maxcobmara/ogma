class Staff::TravelClaimsController < ApplicationController
  filter_access_to :index, :new, :create, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :check, :approval, :claimprint, :attribute_check => true
  before_action :set_travel_claim, only: [:show, :edit, :update, :destroy]
  before_action :set_admin, only: [:index, :new, :edit,:create, :update, :show, :travelclaim_list]
  
  def index
    if @is_admin || @is_finance
      @search = TravelClaim.search(params[:q])
    else
      @search = TravelClaim.sstaff2(current_user.userable.id).search(params[:q])
    end 
    @travel_claims = @search.result.order(staff_id: :asc, claim_month: :asc)

     respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @travel_claims }
    end
  end
  
  def show
    @travel_claim = TravelClaim.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @travel_claim }
    end
  end

  # GET /travel_claims/new
  # GET /travel_claims/new.xml
  def new
    @travel_claim = TravelClaim.new
    #@generated_code = SecureRandom.hex 8
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @travel_claim }
    end
  end

  # GET /travel_claims/1/edit
  def edit
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  def check
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  def approval
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  # POST /travel_claims
  # POST /travel_claims.xml
  def create
    @travel_claim = TravelClaim.new(travel_claim_params)
    #@travelrequests = params[:travel_claim][:travel_request_ids] #array
    @travelrequests= params[:travel_request_ids]
    if @travelrequests
      @travelrequest_ids=[]
      @travelrequests.each{|x|@travelrequest_ids << x.to_i}
    end
    respond_to do |format|
      if @travel_claim.claim_month && @travel_claim.staff_id && @travelrequests  #@travel_claim.valid? && @travelrequests
        @travel_claim.save!
          TravelRequest.where('id IN (?)', @travelrequest_ids).update_all(travel_claim_id: @travel_claim.id)
          format.html { redirect_to(staff_travel_claim_path(@travel_claim), :notice =>t('staff.travel_claim.title')+t('actions.created')) }
          format.xml  { render :xml => @travel_claim, :status => :created, :location => @travel_claim }
      else
	  msg=""
	  msg_count=0
          if @travel_claim.claim_month.blank?
	    msg+="<li>"+t('staff.travel_claim.claim_month_must_exist')+"</li>"
	    msg_count+=1
	  end
	  if @travel_claim.staff_id.blank?
	    msg+="<li>"+t('staff.travel_claim.staff_must_exist')+"</li>"
	    msg_count+=1
	  end
	  if !@travelrequests
	    msg+="<li>"+t('staff.travel_claim.travel_requests_must_exist')+"</li>"
	    msg_count+=1
	  end
	  flash[:notice]=("<font style='color: red;'>#{(t 'errors_title')} #{msg_count} #{(t 'error')} : <ul>#{msg}</font></ul>").html_safe
	  format.html { render :action => "new" }
          format.xml  { render :xml => @travel_claim.errors, :status => :unprocessable_entity }
      end
      
    end
  end

  # PUT /travel_claims/1
  # PUT /travel_claims/1.xml 
  def update
    @travel_claim = TravelClaim.find(params[:id])

    respond_to do |format|
      if @travel_claim.update(travel_claim_params)
        format.html { redirect_to(staff_travel_claim_path(@travel_claim), :notice =>t('staff.travel_claim.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
	if @travel_claim.is_checked? && !@travel_claim.approved_by?
          format.html { render :action => "check" }
          format.xml  { render :xml => @travel_claim.errors, :status => :unprocessable_entity }
	elsif @travel_claim.is_approved? && @travel_claim.approved_on.blank?
	  format.html { render :action => "approval" }
          format.xml  { render :xml => @travel_claim.errors, :status => :unprocessable_entity }
	else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @travel_claim.errors, :status => :unprocessable_entity }
	end
      end
    end
  end

  # DELETE /travel_requests/1
  # DELETE /travel_requests/1.xml
  def destroy
    @travel_claim = TravelClaim.find(params[:id])
    @travel_claim.destroy

    respond_to do |format|
      format.html { redirect_to(staff_travel_claims_url) }
      format.xml  { head :ok }
    end
  end
  
  def claimprint
    @travel_claim = TravelClaim.find(params[:id])
   #@travelclaimlog = TravelClaimLog.where('travel_request_id =?', travel_request.id )
    respond_to do |format|
      format.pdf do
        pdf = ClaimprintPdf.new(@travel_claim, current_user.college, view_context)
        send_data pdf.render, filename: "claimprint-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def travelclaim_list
    if @is_admin || @is_finance
      @search = TravelClaim.search(params[:q])
    else
      @search = TravelClaim.sstaff2(current_user.userable.id).search(params[:q])
    end 
    @travel_claims = @search.result.order(staff_id: :asc, claim_month: :asc)
    respond_to do |format|
      format.pdf do
        pdf = Travelclaim_listPdf.new(@travel_claims, current_user, view_context, current_user.college)
        send_data pdf.render, filename: "travelclaim_list-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
  
  def set_travel_claim
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  def set_admin
    roles = current_user.roles.pluck(:authname)
    #mypost = Position.where(staff_id: current_user.userable_id).first
    @is_admin = true if roles.include?("developer") || roles.include?("administration") || roles.include?("travel_claims_module_admin")|| roles.include?("travel_claims_module_viewer")|| roles.include?("travel_claims_module_user")# || mypost.is_root? || roles.include?("finance_unit")
    @is_finance=true if roles.include?("finance_unit")
  end
  
  def travel_claim_params
    params.require(:travel_claim).permit(:jobtype, :travel_request_ids, :staff_id, :claim_month, :advance, :total, :is_submitted, :submitted_on, :is_checked, :is_returned, :checked_on, :checked_by, :notes, :is_approved, :approved_on, :approved_by, :accommodations, :college_id, {:data => []}, travel_claim_receipts_attributes: [:id,:expenditure_type, :receipt_code, :amount, :checker, :checker_notes, :_destroy], travel_claim_allowances_attributes: [:id, :travel_claim_id, :quantity, :expenditure_type, :amount, :receipt_code,:checker, :checker_notes,:_destroy])  # travel_requests_attributes: [:id, :travel_claim_id],
  end
  
end
