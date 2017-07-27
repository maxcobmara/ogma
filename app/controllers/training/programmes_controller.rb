class Training::ProgrammesController < ApplicationController
  filter_access_to :index, :new, :create, :programme_report, :attribute_check => false
  filter_access_to :show, :edit, :update, :destroy, :attribute_check => true

  before_action :set_programme, only: [:show, :edit, :update, :destroy]
  # GET /programmes
  # GET /programmes.xml
  def index
    @programmes = Programme.all.order(:combo_code)
    #@search = Programme.search(params[:q])
    #@programmes = @search.result

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @programmes }
    end
  end

  # GET /programmes/1
  # GET /programmes/1.xml
  def show
    @programme = Programme.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @programme }
    end
  end

  # GET /programmes/new
  # GET /programmes/new.xml
  def new
    @programme = Programme.new(:parent_id => params[:parent_id])

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @programme }
    end
  end

  # GET /programmes/1/edit
  def edit
    @programme = Programme.find(params[:id])
  end

  # POST /programmes
  # POST /programmes.xml
  def create
    @programme = Programme.new(programme_params)
    respond_to do |format|
      if @programme.save
        format.html { redirect_to(training_programme_path(@programme), :notice => t('training.programme.title')+t('actions.created')) }
        format.xml  { render :xml => @programme, :status => :created, :location => @programme }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @programme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /programmes/1
  # PUT /programmes/1.xml
  def update
    @programme = Programme.find(params[:id])

    respond_to do |format|
      if @programme.update(programme_params)
        format.html { redirect_to(training_programme_url, :notice => t('training.programme.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @programme.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /programmes/1
  # DELETE /programmes/1.xml
  def destroy
    @programme = Programme.find(params[:id])
    #@programme.destroy
    if @programme.destroy
      flash[:notice] = t('training.programme.title')+t('actions.removed')
    else
      flash[:notice] = 'Removal of Subject/Topic is forbidden, due to existance of Subject/Topic in Examquestion.'
    end  

    respond_to do |format|
      format.html { redirect_to(training_programmes_url) }
      format.xml  { head :ok }
    end
  end
  
  def programme_report
    @programmes = Programme.all.order(:combo_code)
    respond_to do |format|
      format.pdf do
        pdf = Programme_reportPdf.new(@programmes, view_context, current_user.college)
        send_data pdf.render, filename: "programme_report-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  def programme_report2
    @programmes = Programme.where(id: params[:ids]).order(:combo_code)
    respond_to do |format|
      format.pdf do
        pdf = Programme_report2Pdf.new(@programmes, view_context, current_user.college)
        send_data pdf.render, filename: "programme_report2-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
                                                       
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_programme
      @programme = Programme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def programme_params
      params.require(:programme).permit(:parent_id, :code, :combo_code, :name, :course_type, :ancestry, :ancestry_depth, :objective, :duration, :duration_type, :credits, :status, :lecture, :tutorial, :practical, :lecture_time, :tutorial_time, :practical_time, :subject_abbreviation, :durationtype, :lecture_d, :tutorial_d, :practical_d, :level, :college_id, {:data => []})
    end
end
