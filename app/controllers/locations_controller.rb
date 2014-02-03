class LocationsController < ApplicationController
  
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
  
  
  
  def show
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:code, :name)
    end
end