class Staff::TravelClaimsController < ApplicationController
  before_action :set_travel_claim, only: [:show, :edit, :update, :destroy]
  def index
    @search = TravelClaim.search(params[:q])
    @travel_claims = @search.result

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
  
  def approve
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  # POST /travel_claims
  # POST /travel_claims.xml
  def create
    @travel_claim = TravelClaim.new(travel_claim_params)
    @travelrequests = params[:travel_claim][:travel_request_ids] #array
    
    respond_to do |format|
      if @travel_claim.save
	TravelRequest.where('id IN (?)',@travelrequests).update_all(travel_claim_id: @travel_claim.id)
        format.html { redirect_to(staff_travel_claim_path(@travel_claim), :notice =>t('staff.travel_claim.title')+t('actions.created')) }
        format.xml  { render :xml => @travel_claim, :status => :created, :location => @travel_claim }
      else
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
        format.html { render :action => "edit" }
        format.xml  { render :xml => @travel_claim.errors, :status => :unprocessable_entity }
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
  
  private
  
  def set_travel_claim
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  def travel_claim_params
    params.require(:travel_claim).permit(:staff_id, :claim_month, :advance, :total, :is_submitted, :submitted_on, :is_checked, :is_returned, :checked_on, :checked_by, :notes, :is_approved, :approved_on, :approved_by, travel_claim_receipts_attributes: [:id,:expenditure_type, :receipt_code, :amount, :checker, :checker_notes, :_destroy], travel_claim_allowances_attributes: [:id, :quantity, :expenditure_type, :amount, :receipt_code,:checker, :checker_notes,:_destroy])
  end
  
end
