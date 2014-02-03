class EventsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  
  def index
    @events = Event.all
  end
  
  def calendar
    @events = Event.find(:all)
    @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timetables }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:event).permit()# <-- insert editable fields here inside here e.g (:date, :name)
    end
end
