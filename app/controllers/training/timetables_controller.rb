class Training::TimetablesController < ApplicationController
  filter_resource_access
  before_action :set_timetable, only: [:show, :edit, :update, :destroy]
  # GET /timetables
  # GET /timetables.xml
  def index
    @timetables = Timetable.all

    @search = Timetable.search(params[:q])
    @timetables = @search.result
    @timetables = @timetables.page(params[:page]||1)  

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @timetables }
    end
  end

  # GET /timetables/1
  # GET /timetables/1.xml
  def show
    @timetable = Timetable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @timetable }
    end
  end

  # GET /timetables/new
  # GET /timetables/new.xml
  def new
    @timetable = Timetable.new
    @timetable.timetable_periods.build

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @timetable }
    end
  end

  # GET /timetables/1/edit
  def edit
    @timetable = Timetable.find(params[:id])
  end

  # POST /timetables
  # POST /timetables.xml
  def create
    @timetable = Timetable.new(timetable_params)
    respond_to do |format|
      if @timetable.save
        format.html { redirect_to(training_timetable_path(@timetable), :notice => (t 'training.timetable.title')+(t 'actions.created')) }
        format.xml  { render :xml => @timetable, :status => :created, :location => @timetable }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @timetable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /timetables/1
  # PUT /timetables/1.xml
  def update
    @timetable = Timetable.find(params[:id])
    respond_to do |format|
      if @timetable.update(timetable_params)
        format.html { redirect_to(training_timetable_path(@timetable), :notice => (t 'training.timetable.title')+(t 'actions.updated'))}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit"}
        format.xml  { render :xml => @timetable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /timetables/1
  # DELETE /timetables/1.xml
  def destroy
    @timetable = Timetable.find(params[:id])
    @timetable.destroy

    respond_to do |format|
      format.html { redirect_to(training_timetables_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timetable
      @timetable = Timetable.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def timetable_params
      params.require(:timetable).permit(:code, :name, :description, :created_by, :college_id, {:data => []}, timetable_periods_attributes: [:id, :timetable_id, :sequence, :day_name, :start_at, :end_at, :is_break, :_destroy, :college_id, :non_class, {:data => []}])
    end
end
