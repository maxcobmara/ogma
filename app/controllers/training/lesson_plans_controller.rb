class Training::LessonPlansController < ApplicationController
   before_action :set_lesson_plan, only: [:show, :edit, :update, :destroy]
  # GET /lesson_plans
  # GET /lesson_plans.xml
  def index
    @search = LessonPlan.search(params[:q])
    @lesson_plans2 = @search.result
    @lesson_plans3 = @lesson_plans2.sort_by{|t|t.lecturer} 
    @lesson_plans =  Kaminari.paginate_array(@lesson_plans3).page(params[:page]||1) 

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lesson_plans }
    end
  end

  # GET /lesson_plans/1
  # GET /lesson_plans/1.xml
  def show
    @lesson_plan = LessonPlan.find(params[:id])
    @current_roles=[]
    current_user.roles.each do |x|
      @current_roles << x.name
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lesson_plan }
    end
  end

  # GET /lesson_plans/new
  # GET /lesson_plans/new.xml
  def new
    @lesson_plan = LessonPlan.new
    @current_roles=[]
    current_user.roles.each do |x|
      @current_roles << x.name
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lesson_plan }
    end
  end

  # GET /lesson_plans/1/edit
  def edit
    @lesson_plan = LessonPlan.find(params[:id])
    @current_roles=[]
    current_user.roles.each do |x|
      @current_roles << x.name
    end
  end

  # POST /lesson_plans
  # POST /lesson_plans.xml
  def create
    @lesson_plan = LessonPlan.new(lesson_plan_params)
    respond_to do |format|
      if @lesson_plan.save
        format.html { redirect_to(training_lesson_plan_path(@lesson_plan), :notice => t('training.lesson_plan.title')+t('actions.created')) }
        format.xml  { render :xml => @lesson_plan, :status => :created, :location => @lesson_plan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lesson_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lesson_plans/1
  # PUT /lesson_plans/1.xml
  def update
    #raise params.inspect
    @lesson_plan = LessonPlan.find(params[:id])
    @current_roles=[]
    current_user.roles.each do |x|
      @current_roles << x.name
    end 

    respond_to do |format|
      if @lesson_plan.update(lesson_plan_params)
        format.html { redirect_to(training_lesson_plan_path(@lesson_plan), :notice => t('training.lesson_plan.title')+t('actions.updated')) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lesson_plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lesson_plans/1
  # DELETE /lesson_plans/1.xml
  def destroy
    @lesson_plan = LessonPlan.find(params[:id])
    @lesson_plan.destroy

    respond_to do |format|
      format.html { redirect_to(training_lesson_plans_url) }
      format.xml  { head :ok }
    end
  end
  
  def lesson_plan
      @lesson_plan = LessonPlan.find(params[:id])
      #render :layout => 'report'
      #respond_to do |format|
      #format.pdf do
        #pdf = Borang_maklumat_staffPdf.new(@staff, view_context)
        #send_data pdf.render, filename: "borang_maklumat_staff-{Date.today}",
                              #type: "application/pdf",
                              #disposition: "inline"
      #end
    #end
  end
  
  def lessonplan_reporting
      @lesson_plan = LessonPlan.find(params[:id])  
      
  end
  def index_report
      #@lesson_plans = LessonPlan.where('hod_approved=?', true) 
      @search = LessonPlan.search(params[:q])
      @lesson_plans2 = @search.result.where('hod_approved=?', true)
      @lesson_plans3 = @lesson_plans2.sort_by{|t|t.lecturer} 
      @lesson_plans =  Kaminari.paginate_array(@lesson_plans3).page(params[:page]||1) 
  end
  def lesson_report
      @lesson_plan = LessonPlan.find(params[:id])
      @current_roles=[]
      current_user.roles.each do |x|
	@current_roles << x.name
      end
      #render :layout => 'report'
      #respond_to do |format|
      #format.pdf do
        #pdf = Borang_maklumat_staffPdf.new(@staff, view_context)
        #send_data pdf.render, filename: "borang_maklumat_staff-{Date.today}",
                              #type: "application/pdf",
                              #disposition: "inline"
      #end
    #end
  end
  
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson_plan
    @lesson_plan = LessonPlan.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_plan_params
    params.require(:lesson_plan).permit(:lecturer, :intake_id, :student_qty, :semester, :topic, :lecture_title, :lecture_date, :start_time, :end_time, :reference, :is_submitted, :submitted_on, :hod_approved, :hod_approved_on, :hod_rejected, :hod_rejected_on, :data, :prerequisites, :year, :reason, :prepared_by, :endorsed_by, :condition_isgood, :condition_isnotgood, :condition_desc, :training_aids, :summary, :total_absent, :report_submit, :report_submit_on, :report_endorsed, :report_endorsed_on, :report_summary, :schedule,  lessonplan_methodologies_attributes: [:id,:content,:lecturer_activity, :student_activity, :training_aids, :evaluation, :start_meth, :end_meth, :_destroy], lesson_plan_trainingnotes_attributes: [:id,:_destroy,:lesson_plan_id,:trainingnote_id], trainingnotes_attributes: [:id,:_destroy,:document,:timetable_id,:staff_id,:title] )
  end
  
end
 
