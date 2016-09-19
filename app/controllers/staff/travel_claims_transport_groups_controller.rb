class Staff::TravelClaimsTransportGroupsController < ApplicationController
  filter_resource_access
  before_action :set_travel_claims_transport_group, only: [:show, :edit, :update, :destroy]
  # GET /travel_claims_transport_groups
  # GET /travel_claims_transport_groups.xml

  def index
    @search = TravelClaimsTransportGroup.search(params[:q])
    @travel_claims_transport_groups = @search.result
    @travel_claims_transport_groups = @travel_claims_transport_groups.page(params[:page]||1)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @travel_claims_transport_groups }
    end
  end

  def new
    @travel_claims_transport_group=TravelClaimsTransportGroup.new
  end
  
  def create
    @travel_claims_transport_group=TravelClaimsTransportGroup.new(travel_claims_transport_group_params)
    respond_to do |format|
      if @travel_claims_transport_group.save
        format.html { redirect_to staff_travel_claims_transport_group_path(@travel_claims_transport_group), :notice =>t('staff.travel_claims_transport_groups.title')+t('actions.created')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @travel_claims_transport_group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # GET /travel_claims_transport_groups/1/edit
  def edit
    @travel_claims_transport_group = TravelClaimsTransportGroup.find(params[:id])
  end

  # PUT /travel_claims_transport_groups/1
  # PUT /travel_claims_transport_groups/1.xml
  def update
    @travel_claims_transport_group = TravelClaimsTransportGroup.find(params[:id])

    respond_to do |format|
      if @travel_claims_transport_group.update(travel_claims_transport_group_params)
        format.html { redirect_to staff_travel_claims_transport_group_path(@travel_claims_transport_group), :notice =>t('staff.travel_claims_transport_groups.title')+t('actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @travel_claims_transport_group.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @travel_claims_transport_group = TravelClaimsTransportGroup.find(params[:id])
  end
  
  def destroy
    @travel_claims_transport_group = TravelClaimsTransportGroup.find(params[:id])
    @travel_claims_transport_group.destroy

    respond_to do |format|
      format.html { redirect_to(staff_travel_claims_transport_groups_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
    def set_travel_claims_transport_group
      @travel_claims_transport_group = TravelClaimsTransportGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def travel_claims_transport_group_params
      params.require(:travel_claims_transport_group).permit(:group_name, :salary_low, :salary_high, :cc_low, :cc_high, :college_id, {:data => []})
    end

end
