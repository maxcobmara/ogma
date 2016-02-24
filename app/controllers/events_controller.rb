class EventsController < ApplicationController
  filter_access_to :index, :new, :create, :attribute_check => false  #calendar
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
  helper_method :sort_column, :sort_direction
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @search = Event.search(params[:q])
    @events = @search.result
    @events = @events.order(:start_at).reverse_order.page(params[:page]||1)
  end

  def calendar
    @events = Event.all
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
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'A new event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
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
      params.require(:event).permit(:eventname, :start_at, :end_at, :location, :participants, :officiated, :createdby)# <-- insert editable fields here inside here e.g (:date, :name)
    end

end
