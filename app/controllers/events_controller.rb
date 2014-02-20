class EventsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  
  def index
    @search = Event.search(params[:q])
    @events = @search.result
    @events = @events.page(params[:page]||1)
    #previous
    #@staff_filtered = Staff.with_permissions_to(:edit).find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['icno LIKE ? or name ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
    @event_filtered = Event.find(:all, :order => sort_column + ' ' + sort_direction ,:conditions => ['eventname LIKE ? or location ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%"])
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
      params.require(:event).permit(:eventname, :location, :date)# <-- insert editable fields here inside here e.g (:date, :name)
    end
    
    def sort_column
        Staff.column_names.include?(params[:sort]) ? params[:sort] : "eventname" 
    end
    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end
end
