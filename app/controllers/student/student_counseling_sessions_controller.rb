class Student::StudentCounselingSessionsController < ApplicationController
  
  before_action :set_student_counseling_session, only: [:show, :edit, :update, :destroy]
   
  # GET /student_counseling_sessions
  # GET /student_counseling_sessions.xml
  def index
    @search = StudentCounselingSession.search(params[:q])
    @appointments = @search.result.find_appointment
    @appointments = @appointments.page(params[:page]||1)  
    @session_dones = @search.result.find_session_done
    #@session_dones = @session_dones.page(params[:page]||1)
    @student_counseling_sessions = @search.result
    @student_counseling_sessions = @student_counseling_sessions.page(params[:page]||1)
    
    @appointments_by_case = @appointments.group_by{|item|item.case_id}
    @session_dones_by_case = @session_dones.group_by{|item|item.case_id}
    
    @sdc=[]
    @session_dones_by_case.each do |caseid, ss|
      @sdc << ss
    end
    
    @sdc =  Kaminari.paginate_array(@sdc).page(params[:page]||1) 
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @student_counseling_sessions }
    end
  end

  # GET /student_counseling_sessions/1
  # GET /student_counseling_sessions/1.xml
  def show
    @student_counseling_session = StudentCounselingSession.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student_counseling_session }
    end
  end

  # GET /student_counseling_sessions/new
  # GET /student_counseling_sessions/new.xml
  def new
    @student_counseling_session = StudentCounselingSession.new
    @case_id = params[:caseid]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @student_counseling_session }
    end
  end

  # GET /student_counseling_sessions/1/edit
  def edit
    @student_counseling_session = StudentCounselingSession.find(params[:id])
  end

  # POST /student_counseling_sessions
  # POST /student_counseling_sessions.xml
  def create
    @student_counseling_session = StudentCounselingSession.new(student_counseling_session_params)

    respond_to do |format|
      if @student_counseling_session.save
        format.html { redirect_to(student_student_counseling_session_url(@student_counseling_session), :notice =>  t('student.counseling.title')+t('actions.created')) }
        format.xml  { render :xml => @student_counseling_session, :status => :created, :location => @student_counseling_session }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @student_counseling_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /student_counseling_sessions/1
  # PUT /student_counseling_sessions/1.xml
  def update
    @student_counseling_session = StudentCounselingSession.find(params[:id])
    if @student_counseling_session.c_scope=="case"
      @abc = StudentDisciplineCase.find(@student_counseling_session.case_id)
      @feedback = params[:student_counseling_session][:feedback]
      if @feedback==1|| @feedback=='1'
	@abc.counselor_feedback = params[:student_counseling_session][:feedback_final]
      else
	@abc.counselor_feedback =''
      end
      @abc.save
    end
    respond_to do |format|
      if @student_counseling_session.update(student_counseling_session_params)
        format.html { redirect_to(student_student_counseling_session_url(@student_counseling_session), :notice => t('student.counseling.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @student_counseling_session.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /student_counseling_sessions/1
  # DELETE /student_counseling_sessions/1.xml
  def destroy
    @student_counseling_session = StudentCounselingSession.find(params[:id])
    @student_counseling_session.destroy

    respond_to do |format|
      format.html { redirect_to(student_counseling_sessions_url) }
      format.xml  { head :ok }
    end
  end
  
  def feedback
    @student_counseling_session = StudentCounselingSession.find(params[:id])
  end
  
  def feedback_referrer 
    @sessions_by_case = StudentCounselingSession.where('case_id=?',params[:id]).order(confirmed_at: :asc)
    @case_details = StudentDisciplineCase.find(params[:id])
    render :layout => 'report'
  end
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student_counseling_session
      @student_counseling_session = StudentCounselingSession.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_counseling_session_params
      params.require(:student_counseling_session).permit(:student_id, :case_id, :requested_at, :alt_dates, :c_type, :c_scope, :duration, :is_confirmed, :confirmed_at, :issue_desc, :notes, :file_id, :suggestions, :staff_id, :created_by, :created_by_type, :confirmed_by, :confirmed_by_type, :remark)
    end
  
end