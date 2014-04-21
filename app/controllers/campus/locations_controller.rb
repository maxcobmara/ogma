class Campus::LocationsController < ApplicationController
  
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  
  def index
      #@filters = Location::FILTERS
      #if params[:show] && @filters.collect{|f| f[:scope]}.include?(params[:show])
      #  @locations = Location.send(params[:show])
      #else
      #  @locations = Location.search(params[:search])
      #end
      @locations = Location.all
      @root_locations = Location.roots.order(code: :asc)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locations }
    end
  end
  
  def new
    @location = Location.new(:parent_id => params[:parent_id])
  end
  
  def edit
    #@location.damages.new if @location.occupied==0
    #@location.damages.build
  end
  
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        flash[:notice] = 'Location was successfully created.'
        format.html { redirect_to(campus_location_path(@location)) }
        format.xml  { render :xml => @location, :status => :created, :location => @location }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @location.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html {redirect_to campus_location_path(@location.parent || @location), notice: (t 'location.title')+(t 'actions.updated')  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end
    
  
  def show
  end
  
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to campus_locations_url }
      format.json { head :no_content }
    end
  end
  
  def kewpa7
    @location = Location.find(params[:id])
    respond_to do |format|
      format.pdf do
        pdf = Kewpa7Pdf.new(@location, current_user)
        send_data pdf.render, filename: "order_#{@location.combo_code}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:code, :name, :parent_id, :lclass, :typename, :allocatable, :occupied, :staffadmin_id, :staff_name, :ancestry, :parent_code, damages_attributes: [:id, :description,:reported_on,:document_id])
    end
end