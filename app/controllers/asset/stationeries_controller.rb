class Asset::StationeriesController < ApplicationController
  filter_access_to :index, :new, :create, :kewps13, :stationery_details, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  before_action :set_stationery, only: [:show, :edit, :update, :destroy]
  
  def index
    @search = Stationery.search(params[:q])
    @stationeries=@search.result
    @stationeries=@stationeries.order(code: :asc).page(params[:page]||1)
  end
  
  def show
    @stationery = Stationery.find(params[:id])
  end
  
  def new
    @stationery = Stationery.new
  end
  
  def create
    @stationery = Stationery.new(stationery_params)
    respond_to do |format|
      if @stationery.save
        format.html { redirect_to(asset_stationery_path(@stationery), notice: (t 'stationery.title_menu')+(t 'actions.created')) }
        format.json { render action: 'show', status: :created, location: @stationery }
      else
        format.html { render action: 'new' }
        format.json { render json: @stationery.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @stationery = Stationery.find(params[:id])
  end
  
  def update
    @stationery = Stationery.find(params[:id])

    respond_to do |format|
      if @stationery.update(stationery_params)
        format.html { redirect_to asset_stationery_path, notice: (t 'stationery.title_menu')+(t 'actions.updated')}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @stationery.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @stationery.destroy
    respond_to do |format|
      format.html { redirect_to(asset_stationeries_path) } 
      format.xml  { head :ok }
    end
  end
  
  def kewps13
    ryear = params[:yyear]
    r_year = ryear if ryear && ryear!=nil #Date.today.year.to_s #2012.to_s #2013.to_s #"2014"
    reporting_year = (r_year+"-12-31").to_date
    if reporting_year > Date.today
      @reporting_year = Date.today
    else
      @reporting_year = reporting_year
    end
    
    respond_to do |format|
      format.pdf do
        pdf = Kewps13Pdf.new(view_context, @reporting_year)
        send_data pdf.render, filename: "kewps13-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def stationery_details
    @stationery=Stationery.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Stationery_detailsPdf.new(@stationery, view_context, current_user.college)
        send_data pdf.render, filename: "kewps13-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stationery
      @stationery = Stationery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stationery_params
      params.require(:stationery).permit(:code, :category, :unittype, :maxquantity, :minquantity, :college_id, {:data=>[]}, damages_attributes: [:id, :description,:reported_on,:document_id,:location_id], stationery_adds_attributes: [:id, :_destroy, :lpono, :document, :quantity, :unitcost, :received], stationery_uses_attributes: [:id, :_destroy, :issuedby, :receivedby, :quantity, :issuedate])
    end
end