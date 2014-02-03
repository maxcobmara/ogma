class CofilesController < ApplicationController
  
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  # GET /cofiles
  # GET /cofiles.xml
  def index
     @cofiles = Cofile.all
     
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cofiles }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @cofile = Cofile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:cofile).permit()# <-- insert editable fields here inside here e.g (:date, :name)
    end
end