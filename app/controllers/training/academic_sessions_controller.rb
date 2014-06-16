class Training::AcademicSessionsController < ApplicationController
  before_action :set_academic_session, only: [:show, :edit, :update, :destroy]
  # GET /academic_sessions
  # GET /academic_sessions.xml
  def index
    #@academic_sessions = AcademicSession.all

    @search = AcademicSession.search(params[:q])
    @academic_sessions2 = @search.result
    @academic_sessions = @academic_sessions2.page(params[:page]||1)  

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @academic_sessions }
    end
  end

  # GET /academic_sessions/1
  # GET /academic_sessions/1.xml
  def show
    @academic_session = AcademicSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @academic_session }
    end
  end

  # GET /academic_sessions/new
  # GET /academic_sessions/new.xml
  def new
    @academic_session = AcademicSession.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @academic_session }
    end
  end

  # GET /academic_sessions/1/edit
  def edit
    @academic_session = AcademicSession.find(params[:id])
  end

  # POST /academic_sessions
  # POST /academic_sessions.xml
  def create
    @academic_session = AcademicSession.new(params[:academic_session])

    respond_to do |format|
      if @academic_session.save
        format.html { redirect_to(@academic_session, :notice => (t 'training.academic_session.title')+(t 'actions.created')) }
        format.xml  { render :xml => @academic_session, :status => :created, :location => @academic_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @academic_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /academic_sessions/1
  # PUT /academic_sessions/1.xml
  def update
    @academic_session = AcademicSession.find(params[:id])

    respond_to do |format|   
      if @academic_session.update(academic_session_params)
        format.html { redirect_to(training_academic_session_path(@academic_session), :notice => (t 'training.academic_session.title')+(t 'actions.updated'))}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @academic_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /academic_sessions/1
  # DELETE /academic_sessions/1.xml
  def destroy
    @academic_session = AcademicSession.find(params[:id])
    @academic_session.destroy

    respond_to do |format|
      format.html { redirect_to(academic_sessions_url) }
      format.xml  { head :ok }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_academic_session
      @academic_session = AcademicSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def academic_session_params
      params.require(:academic_session).permit(:semester, :total_week)
    end
end
