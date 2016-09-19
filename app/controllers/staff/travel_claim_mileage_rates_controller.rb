class Staff::TravelClaimMileageRatesController < ApplicationController
  filter_resource_access
  before_action :set_travel_claim_mileage_rate, only: [:show, :edit, :update, :destroy]
  # GET /travel_claim_mileage_rates
  # GET /travel_claim_mileage_rates.xml

  def index
    @search = TravelClaimMileageRate.search(params[:q])
    @travel_claim_mileage_rates = @search.result
    @travel_claim_mileage_rates = @travel_claim_mileage_rates.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @travel_claim_mileage_rates }
    end
  end

  def new
    @travel_claim_mileage_rate=TravelClaimMileageRate.new
  end
  
  def create
    @travel_claim_mileage_rate=TravelClaimMileageRate.new(travel_claim_mileage_rate_params)
    respond_to do |format|
      if @travel_claim_mileage_rate.save
        format.html { redirect_to staff_travel_claim_mileage_rates_path, :notice =>t('staff.travel_claim_mileage_rates.title')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @travel_claim_mileage_rate.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /travel_claim_mileage_rates/1/edit
  def edit
    @travel_claim_mileage_rate = TravelClaimMileageRate.find(params[:id])
  end

  # PUT /travel_claim_mileage_rates/1
  # PUT /travel_claim_mileage_rates/1.xml
  def update
    @travel_claim_mileage_rate = TravelClaimMileageRate.find(params[:id])

    respond_to do |format|
      if @travel_claim_mileage_rate.update(travel_claim_mileage_rate_params)
        format.html { redirect_to staff_travel_claim_mileage_rates_path, :notice =>t('staff.travel_claim_mileage_rates.title')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @travel_claim_mileage_rate.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @travel_claim_mileage_rate = TravelClaimMileageRate.find(params[:id])
  end
  
  def destroy
    @travel_claim_mileage_rate = TravelClaimMileageRate.find(params[:id])
    @travel_claim_mileage_rate.destroy

    respond_to do |format|
      format.html { redirect_to(staff_travel_claim_mileage_rates_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_travel_claim_mileage_rate
      @travel_claim_mileage_rate = TravelClaimMileageRate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def travel_claim_mileage_rate_params
      params.require(:travel_claim_mileage_rate).permit(:km_low, :km_high, :a_group, :b_group, :c_group, :d_group, :e_group, :college_id, {:data => []})
    end

end
