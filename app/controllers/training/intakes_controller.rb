class Training::IntakesController < ApplicationController
  filter_access_to :index, :new, :create, :intake_report, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true
    
  before_action :set_intake, only: [:show, :edit, :update, :destroy]
  # GET /intakes
  # GET /intakes.xml
  def index
    @search = Intake.search(params[:q])
    @intakes2 = @search.result
    @intakes3 = @intakes2.page(params[:page]||1)  
    @intakes = @intakes3.order(monthyear_intake: :desc).group_by(&:monthyear_intake)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @intakes }
    end
  end

  # GET /intakes/1
  # GET /intakes/1.xml
  def show
    @intake = Intake.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @intake }
    end
  end

  # GET /intakes/new
  # GET /intakes/new.xml
  def new
    @intake = Intake.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @intake }
    end
  end

  # GET /intakes/1/edit
  def edit
    @intake = Intake.find(params[:id])
  end

  # POST /intakes
  # POST /intakes.xml
  def create
    @intake = Intake.new(intake_params)
    respond_to do |format|
      if @intake.save
#         flash[:notice] = (t 'training.intake.title')+(t 'actions.created')
#         format.html { redirect_to(training_intake_path(@intake)) }
#         format.xml  { render :xml => @intake, :status => :created, :location => @intake }
        format.html { render action: 'edit'}
        format.json { render action: 'show', status: :created, location: @schedule }

      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @intake.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /intakes/1
  # PUT /intakes/1.xml
  def update
    @intake = Intake.find(params[:id])

    respond_to do |format|
      if @intake.update(intake_params)
        format.html { redirect_to(training_intake_path(@intake), :notice => (t 'training.intake.title')+(t 'actions.updated'))}
        format.xml  { head :ok }
	format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @intake.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /intakes/1
  # DELETE /intakes/1.xml
  def destroy
    @intake = Intake.find(params[:id])
    @intake.destroy

    respond_to do |format|
      format.html { redirect_to(training_intakes_url) }
      format.xml  { head :ok }
    end
  end
  
  def intake_report
    @search = Intake.search(params[:q])
    @intakes2 = @search.result
    @intakes3 = @intakes2.page(params[:page]||1)  
    @intakes = @intakes3.order(monthyear_intake: :desc).group_by(&:monthyear_intake)
     respond_to do |format|
       format.pdf do
         pdf = Intake_reportPdf.new(@intakes, view_context, current_user.college)
         send_data pdf.render, filename: "intake_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
       end
     end
  end
   
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_intake
      @intake = Intake.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def intake_params
      #params.require(:intake).permit!
      params.require(:intake).permit(:name, :description, :register_on, :programme_id, :is_active, :monthyear_intake, :staff_id, :college_id, {:data => []}).tap do |whitelisted|
        whitelisted[:division]=params[:intake][:division]
      end
      #ref - http://blog.trackets.com/2013/08/17/strong-parameters-by-example.html
    end

end
