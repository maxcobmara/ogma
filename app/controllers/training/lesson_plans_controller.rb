class Training::LessonPlansController < ApplicationController
   filter_access_to :index, :new, :create, :lessonplan_listing, :attribute_check => false  # :index_report, - no longer use, Inde already combine plan & report
   filter_access_to :show, :edit, :update, :destroy, :lesson_plan,:lesson_report, :lessonplan_reporting, :attribute_check => true 
   before_action :set_index_data, only: [:index, :lessonplan_listing]
   before_action :set_lesson_plan, only: [:show, :edit, :update, :destroy]
   before_action :set_admin, only: [:index, :new, :edit,:update, :show,  :lessonplan_reporting, :index_report, :lessonplan_listing]

  # GET /lesson_plans
  # GET /lesson_plans.xml
  def index
    #reference : Staff Appraisal, Exammark, Exam Template
    if @is_admin
      @search = LessonPlan.search(params[:q])
    else
#       current_roles=current_user.roles.pluck(:authname)
#       if current_roles.include?("programme_manager")
#         @search = LessonPlan.search2(@programme_id).search(params[:q])
#       else
        @search = LessonPlan.sstaff2(current_user.userable.id).search(params[:q])
#       end
    end
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
    @location_display="show"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lesson_plan }
    end
  end

  # GET /lesson_plans/new
  # GET /lesson_plans/new.xml
  def new
    @lesson_plan = LessonPlan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lesson_plan }
    end
  end

  # GET /lesson_plans/1/edit
  def edit
    @lesson_plan = LessonPlan.find(params[:id])
  end
  
  def lessonplan_reporting
    @lesson_plan = LessonPlan.find(params[:id])
    @location_display="reporting"
  end
  
  def add_notes
    @lesson_plan = LessonPlan.find(params[:id])
  end

  # POST /lesson_plans
  # POST /lesson_plans.xml
  def create
    @lesson_plan = LessonPlan.new(lesson_plan_params)
    newlocation = params[:new_location]
    if !newlocation.blank?#!=nil
      scheduleid = params[:lesson_plan][:schedule]
      scheduleid = @lesson_plan.schedule if scheduleid==nil
      if scheduleid!=nil
        schedule = WeeklytimetableDetail.find(scheduleid) 
        schedule.location_desc = newlocation
        schedule.save!
      end
    end
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
    newlocation = params[:new_location]
    if newlocation!=nil
      scheduleid = params[:lesson_plan][:schedule]
      scheduleid = @lesson_plan.schedule if scheduleid==nil
      if scheduleid!=nil
        schedule = WeeklytimetableDetail.find(scheduleid) 
        schedule.location_desc = newlocation
        schedule.save!
      end
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
    respond_to do |format|
      format.pdf do
        pdf = Lesson_planPdf.new(@lesson_plan, view_context, current_user.college)
        send_data pdf.render, filename: "lesson_plan-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def lesson_report
    @lesson_plan = LessonPlan.find(params[:id])   
    respond_to do |format|
      format.pdf do
        pdf = Lesson_reportPdf.new(@lesson_plan, view_context, current_user.college)
        send_data pdf.render, filename: "lesson_report-{Date.today}",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end
  
  def index_report
      #@lesson_plans = LessonPlan.where('hod_approved=?', true) 
      @search = LessonPlan.search(params[:q])
      @lesson_plans2 = @search.result.where('hod_approved=?', true)
      @lesson_plans3 = @lesson_plans2.sort_by{|t|t.lecturer} 
      @lesson_plans =  Kaminari.paginate_array(@lesson_plans3).page(params[:page]||1) 
  end
  
  def lessonplan_listing
    if @is_admin
      @search = LessonPlan.search(params[:q])
    else
#       roles=current_user.roles
#       if roles.include?("programme_manager")
#         @search = LessonPlan.search2(@programme_id).search(params[:q])
#       else
        @search = LessonPlan.sstaff2(current_user.userable.id).search(params[:q])
#       end
    end
    @lesson_plans = @search.result
    #@lesson_plans3 = @lesson_plans.sort_by{|t|t.lecturer} 
    respond_to do |format|
      format.pdf do
        pdf = Lessonplan_listingPdf.new(@lesson_plans, view_context, current_user.college)
        send_data pdf.render, filename: "lessonplan_listing-{Date.today}",
                               type: "application/pdf",
                               disposition: "inline"
      end
    end
  end
  
  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_lesson_plan
    @lesson_plan = LessonPlan.find(params[:id])
  end
  
  def set_admin
    roles = current_user.roles.pluck(:authname)
    @is_admin = roles.include?("developer") || roles.include?("administration") || roles.include?("lesson_plans_module_admin") || roles.include?("lesson_plans_module_viewer") || roles.include?("lesson_plans_module_user")
  end
  
  #sample from exam_templates########
  def set_index_data
    position_exist = @current_user.userable.positions
    roles= @current_user.roles.pluck(:authname)
    @is_admin=true if roles.include?("administration") || roles.include?("lesson_plans_module")
    posbasiks=["Pos Basik", "Diploma Lanjutan", "Pengkhususan"]
    @common_subjects=['Sains Tingkahlaku','Sains Perubatan Asas', 'Komunikasi & Sains Pengurusan', 'Anatomi & Fisiologi', 'Komuniti']
    if position_exist && position_exist.count > 0
      lecturer_programme = @current_user.userable.positions[0].unit
      unless lecturer_programme.nil?
        programme = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{lecturer_programme}%",0)  if posbasiks.include?(lecturer_programme)==false
      end
      unless programme.nil? || programme.count==0
        programme_id = programme.try(:first).try(:id)
      else
        tasks_main = @current_user.userable.positions[0].tasks_main
        if @common_subjects.include?(lecturer_programme) 
          programme_id ='1'
        elsif posbasiks.include?(lecturer_programme) && tasks_main!=nil
          programme_id='2'
        else
          leader_unit=tasks_main.scan(/Program (.*)/)[0][0].split(" ")[0] if tasks_main!="" && tasks_main.include?('Program')
          if leader_unit
            programme_id = Programme.where('name ILIKE (?) AND ancestry_depth=?',"%#{leader_unit}%",0).first.id
          end
        end
      end
      @programme_id=programme_id
    end
  end
  #########
  
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def lesson_plan_params
    params.require(:lesson_plan).permit(:lecturer, :whoami, :intake_id, :student_qty, :location, :semester, :topic, :lecture_title, :lecture_date, :start_time, :end_time, :reference, :is_submitted, :submitted_on, :hod_approved, :hod_approved_on, :hod_rejected, :hod_rejected_on, :data, :prerequisites, :year, :reason, :prepared_by, :endorsed_by, :condition_isgood, :condition_isnotgood, :condition_desc, :training_aids, :summary, :total_absent, :report_submit, :report_submit_on, :report_endorsed, :report_endorsed_on, :report_summary, :schedule, :college_id, {:college_data=>[]}, :data_title, lessonplan_methodologies_attributes: [:id,:content,:lecturer_activity, :student_activity, :training_aids, :evaluation, :start_meth, :end_meth, :_destroy, :college_id], lesson_plan_trainingnotes_attributes: [:id,:_destroy,:lesson_plan_id,:trainingnote_id], trainingnotes_attributes: [:id,:_destroy,:document,:timetable_id,:staff_id,:title] )
  end
  
end
 
