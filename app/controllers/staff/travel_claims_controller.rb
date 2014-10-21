class Staff::TravelClaimsController < ApplicationController
  before_action :set_travel_claim, only: [:show, :edit, :update, :destroy]
  def index
    #@travel_claims = TravelClaim.all
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

  # GET /travel_requests/1/edit
  def edit
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  private
  
  def set_travel_claim
    @travel_claim = TravelClaim.find(params[:id])
  end
  
  def travel_claim_params
    params.require(:travel_claim).permit(:staff_id, :claim_month, :advance, :total, :is_submitted, :submitted_on, :is_checked, :is_returned, :checked_on, :checked_by, :notes, :is_approved, :approved_on, :approved_by, travel_requests_atributes: [:id, :_destroy])
  end
  
end
