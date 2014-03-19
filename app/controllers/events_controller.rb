class EventsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @search = Event.search(params[:q])
    @events = @search.result
    @events = @events.page(params[:page]||1)
  end

  
  def calendar
    @events = Event.find(:all)
    @date = params[:month] ? Date.parse(params[:month].gsub('-', '/')) : Date.today

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timetables }
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'A new event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_path, notice: 'Event List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.json { head :no_content }
    end
  end

  def edit
    @event = Event.find(params[:id])
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:eventname, :start_at, :end_at, :location, :participants, :officiated, :staff_name)# <-- insert editable fields here inside here e.g (:date, :name)
    end
    
    def sort_column
        Event.column_names.include?(params[:sort]) ? params[:sort] : "eventname" 
    end
    
    def sort_direction
        %w[asc desc].include?(params[:direction])? params[:direction] : "asc" 
    end
end
